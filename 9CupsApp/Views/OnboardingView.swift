import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isOnboarding: Bool
    @State private var page = 0
    @State private var nameInput = ""
    @State private var selectedLevel: Int16 = 1

    var body: some View {
        ZStack {
            CupsTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Pages
                Group {
                    switch page {
                    case 0: welcomePage
                    case 1: levelPage
                    case 2: namePage
                    default: EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))

                Spacer()

                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(i == page ? CupsTheme.primaryAccent : CupsTheme.primaryAccent.opacity(0.2))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)

                // Button
                Button(action: advance) {
                    Text(page == 2 ? "Let's go" : "Continue")
                        .font(CupsTheme.headerFont(18))
                        .foregroundColor(CupsTheme.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(CupsTheme.primaryAccent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .accessibilityLabel(page == 2 ? "Start tracking" : "Continue")
            }
        }
    }

    // MARK: - Pages

    private var welcomePage: some View {
        VStack(spacing: 20) {
            // Rainbow ring logo
            RainbowLogoView()
                .frame(width: 120, height: 120)

            Text("9 Cups")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text("Track your daily nutrition\nwith zero friction.")
                .font(CupsTheme.bodyFont(16))
                .foregroundColor(CupsTheme.textSecondary)
                .multilineTextAlignment(.center)

            Text("Inspired by the Wahls Protocol®\nfor MS and autoimmune conditions.")
                .font(CupsTheme.bodyFont(13))
                .foregroundColor(CupsTheme.textSecondary.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding(.horizontal, 32)
    }

    private var levelPage: some View {
        VStack(spacing: 24) {
            Text("Pick your level")
                .font(CupsTheme.headerFont(26))
                .foregroundColor(.white)

            Text("You can change this anytime.")
                .font(CupsTheme.bodyFont(14))
                .foregroundColor(CupsTheme.textSecondary)

            VStack(spacing: 12) {
                ForEach(NineCupsProtocol.levels) { level in
                    Button(action: { selectedLevel = Int16(level.id) }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Level \(level.id)")
                                    .font(CupsTheme.headerFont(16))
                                    .foregroundColor(.white)
                                Text(level.name)
                                    .font(CupsTheme.bodyFont(13))
                                    .foregroundColor(CupsTheme.textSecondary)
                            }
                            Spacer()
                            if selectedLevel == Int16(level.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(CupsTheme.primaryAccent)
                                    .font(.system(size: 24))
                            } else {
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(16)
                        .background(
                            selectedLevel == Int16(level.id)
                                ? CupsTheme.primaryAccent.opacity(0.1)
                                : CupsTheme.cardBackground
                        )
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    selectedLevel == Int16(level.id)
                                        ? CupsTheme.primaryAccent.opacity(0.4)
                                        : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                    }
                    .accessibilityLabel("Level \(level.id), \(level.name)")
                }
            }
        }
        .padding(.horizontal, 32)
    }

    private var namePage: some View {
        VStack(spacing: 20) {
            Text("What should we call you?")
                .font(CupsTheme.headerFont(26))
                .foregroundColor(.white)

            Text("First name or alias. Stays on your device.")
                .font(CupsTheme.bodyFont(14))
                .foregroundColor(CupsTheme.textSecondary)

            TextField("", text: $nameInput)
                .placeholder(when: nameInput.isEmpty) {
                    Text("e.g. Aaron")
                        .foregroundColor(.white.opacity(0.25))
                }
                .font(CupsTheme.bodyFont(18))
                .foregroundColor(.white)
                .padding(16)
                .background(CupsTheme.cardBackground)
                .cornerRadius(14)
                .submitLabel(.done)
                .onSubmit { advance() }
                .accessibilityLabel("Your name or alias")
        }
        .padding(.horizontal, 32)
    }

    // MARK: - Actions

    private func advance() {
        if page < 2 {
            withAnimation(.easeInOut(duration: 0.3)) {
                page += 1
            }
        } else {
            // Save and finish
            appState.updateLevel(selectedLevel)
            let trimmed = nameInput.trimmingCharacters(in: .whitespaces)
            if !trimmed.isEmpty {
                appState.updateDisplayName(trimmed)
            }
            withAnimation {
                isOnboarding = false
            }
        }
    }
}

// MARK: - Placeholder helper
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Rainbow Wheel Logo

struct RainbowLogoView: View {
    let lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            // Green arc (leafy greens)
            ArcSegment(startAngle: -90, endAngle: 30)
                .stroke(Color(red: 0.29, green: 0.87, blue: 0.5), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Orange arc (colored veg)
            ArcSegment(startAngle: 35, endAngle: 155)
                .stroke(Color(red: 0.98, green: 0.57, blue: 0.24), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Purple arc (sulfur-rich)
            ArcSegment(startAngle: 160, endAngle: 265)
                .stroke(Color(red: 0.65, green: 0.55, blue: 0.98), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Inner text
            VStack(spacing: 0) {
                Text("9")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("cups")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.29, green: 0.87, blue: 0.5))
            }
        }
        .padding(lineWidth / 2)
    }
}

struct ArcSegment: Shape {
    let startAngle: Double
    let endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )
        return path
    }
}
