import SwiftUI
import PhotosUI

struct PhotoCheckInView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var state: CheckInState = .picking
    @State private var increments: PhotoIncrements?
    @State private var errorMessage: String?
    @State private var toggleStates: [String: Bool] = [:]

    enum CheckInState {
        case picking, analyzing, results, error
    }

    var body: some View {
        NavigationView {
            ZStack {
                CupsTheme.background.ignoresSafeArea()

                switch state {
                case .picking:
                    pickerView
                case .analyzing:
                    analyzingView
                case .results:
                    resultsView
                case .error:
                    errorView
                }
            }
            .navigationTitle("Snap & Track")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(CupsTheme.textSecondary)
                }
            }
        }
    }

    // MARK: - Picker View

    private var pickerView: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("📸")
                .font(.system(size: 64))

            Text("Take a photo of your meal")
                .font(CupsTheme.headerFont(22))
                .foregroundColor(CupsTheme.textPrimary)
                .multilineTextAlignment(.center)

            Text("AI will identify Wahls Protocol foods\nand fill your cups automatically.")
                .font(CupsTheme.bodyFont(15))
                .foregroundColor(CupsTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            VStack(spacing: 14) {
                // Camera capture
                Button {
                    // Camera handled via sheet — see CameraPickerButton below
                } label: {
                    Label("Take Photo", systemImage: "camera.fill")
                        .font(CupsTheme.labelFont(16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(CupsTheme.primaryAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                }
                .overlay(CameraPickerButton(onImage: handleImageSelected))
                .clipShape(RoundedRectangle(cornerRadius: 13))

                // Photo library
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Choose from Library", systemImage: "photo.on.rectangle")
                        .font(CupsTheme.labelFont(16))
                        .foregroundColor(CupsTheme.primaryAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .overlay(
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(CupsTheme.primaryAccent, lineWidth: 1.5)
                        )
                }
                .onChange(of: selectedPhoto) { item in
                    Task {
                        if let data = try? await item?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            await handleImageSelected(image)
                        }
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }

    // MARK: - Analyzing View

    private var analyzingView: some View {
        VStack(spacing: 24) {
            Spacer()

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(CupsTheme.background.opacity(0.5))
                    )
            }

            VStack(spacing: 10) {
                ProgressView()
                    .tint(CupsTheme.primaryAccent)
                    .scaleEffect(1.2)
                Text("Analyzing your meal...")
                    .font(CupsTheme.bodyFont(16))
                    .foregroundColor(CupsTheme.textSecondary)
            }

            Spacer()
        }
    }

    // MARK: - Results View

    private var resultsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Thumbnail
                if let image = selectedImage {
                    HStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }

                if let inc = increments {
                    // Foods detected
                    if !inc.foodsDetected.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Found in your meal")
                                .font(CupsTheme.labelFont(13))
                                .foregroundColor(CupsTheme.textSecondary)
                                .textCase(.uppercase)
                                .tracking(0.5)

                            Text(inc.foodsDetected.joined(separator: ", "))
                                .font(CupsTheme.bodyFont(15))
                                .foregroundColor(CupsTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }

                    // Increment line items
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Adding to today's cups")
                            .font(CupsTheme.labelFont(13))
                            .foregroundColor(CupsTheme.textSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                            .padding(.bottom, 4)

                        ForEach(inc.lineItems, id: \.key) { item in
                            HStack {
                                Text(item.emoji)
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.label)
                                        .font(CupsTheme.bodyFont(15))
                                        .foregroundColor(CupsTheme.textPrimary)
                                    Text(item.detail)
                                        .font(CupsTheme.labelFont(13))
                                        .foregroundColor(CupsTheme.primaryAccent)
                                }
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { toggleStates[item.key] ?? true },
                                    set: { toggleStates[item.key] = $0 }
                                ))
                                .tint(CupsTheme.primaryAccent)
                                .labelsHidden()
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(CupsTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 20)

                    // Confidence note
                    if inc.confidence == "low" {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)
                            Text("Low confidence — review before saving.")
                                .font(CupsTheme.labelFont(12))
                                .foregroundColor(CupsTheme.textSecondary)
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        applyIncrements()
                    } label: {
                        Text("Looks good!")
                            .font(CupsTheme.labelFont(17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(CupsTheme.primaryAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 13))
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Skip")
                            .font(CupsTheme.labelFont(16))
                            .foregroundColor(CupsTheme.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Error View

    private var errorView: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("🤷")
                .font(.system(size: 56))

            Text(errorMessage ?? "Couldn't analyze this one.")
                .font(CupsTheme.bodyFont(16))
                .foregroundColor(CupsTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            HStack(spacing: 14) {
                Button {
                    state = .picking
                    selectedImage = nil
                } label: {
                    Text("Try Again")
                        .font(CupsTheme.labelFont(16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(CupsTheme.primaryAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    dismiss()
                } label: {
                    Text("Add Manually")
                        .font(CupsTheme.labelFont(16))
                        .foregroundColor(CupsTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(CupsTheme.textSecondary.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }

    // MARK: - Logic

    @MainActor
    private func handleImageSelected(_ image: UIImage) async {
        selectedImage = image
        state = .analyzing

        do {
            let result = try await FoodPhotoAnalyzer.shared.analyze(image: image)
            increments = result
            // Initialize all toggles to ON
            for item in result.lineItems {
                toggleStates[item.key] = true
            }
            state = .results
        } catch {
            errorMessage = error.localizedDescription
            state = .error
        }
    }

    private func applyIncrements() {
        guard var inc = increments else { return }

        // Zero out any toggled-off items
        if toggleStates["leafy"] == false { inc.leafyGreens = 0 }
        if toggleStates["redpurple"] == false { inc.redPurple = 0 }
        if toggleStates["orangeyellow"] == false { inc.orangeYellow = 0 }
        if toggleStates["blueblack"] == false { inc.blueBlack = 0 }
        if toggleStates["sulfur"] == false { inc.sulfurRich = 0 }
        if toggleStates["protein"] == false { inc.proteinOz = 0 }
        if toggleStates["seaweed"] == false { inc.seaweed = false }
        if toggleStates["fermented"] == false { inc.fermented = false }
        if toggleStates["organ"] == false { inc.organMeatOz = 0 }

        appState.applyPhotoIncrements(inc)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dismiss()
    }
}

// MARK: - Camera Picker (UIImagePickerController wrapper)

struct CameraPickerButton: UIViewControllerRepresentable {
    let onImage: (UIImage) async -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onImage: onImage) }

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ vc: UIViewController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImage: (UIImage) async -> Void
        init(onImage: @escaping (UIImage) async -> Void) { self.onImage = onImage }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            if let image = info[.originalImage] as? UIImage {
                Task { await onImage(image) }
            }
        }
    }
}
