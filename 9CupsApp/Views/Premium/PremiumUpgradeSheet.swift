import SwiftUI

struct PremiumUpgradeSheet: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @Environment(\.dismiss) private var dismiss
    @State private var errorMessage: String?
    @State private var showError = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            CupsTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    Spacer(minLength: 48)

                    // Icon
                    Text("📸")
                        .font(.system(size: 72))

                    // Headline
                    VStack(spacing: 10) {
                        Text("Snap & Track")
                            .font(CupsTheme.headerFont(32))
                            .foregroundColor(CupsTheme.textPrimary)

                        Text("Point your camera at any meal.\nAI fills your cups automatically.")
                            .font(CupsTheme.bodyFont(16))
                            .foregroundColor(CupsTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 24)

                    // Feature bullets
                    VStack(alignment: .leading, spacing: 16) {
                        featureBullet(icon: "camera.fill", text: "Identify foods from any photo")
                        featureBullet(icon: "circle.grid.3x3.fill", text: "Auto-fill your cups and rainbow ring")
                        featureBullet(icon: "slider.horizontal.3", text: "Review and adjust before saving")
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .background(CupsTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 24)

                    // CTA
                    VStack(spacing: 14) {
                        if premiumManager.isPurchasing {
                            ProgressView()
                                .tint(CupsTheme.textPrimary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        } else {
                            Button {
                                Task { await handlePurchase() }
                            } label: {
                                Text("Unlock Premium — $4.99")
                                    .font(CupsTheme.labelFont(17))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(CupsTheme.primaryAccent)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .padding(.horizontal, 24)
                        }

                        Button {
                            Task { await handleRestore() }
                        } label: {
                            Text("Restore Purchase")
                                .font(CupsTheme.labelFont(14))
                                .foregroundColor(CupsTheme.textSecondary)
                        }
                    }

                    Text("One-time purchase. No subscription.")
                        .font(CupsTheme.labelFont(12))
                        .foregroundColor(CupsTheme.textSecondary.opacity(0.6))
                        .padding(.bottom, 32)
                }
            }

            // Dismiss button
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(CupsTheme.textSecondary.opacity(0.5))
            }
            .padding(16)
        }
        .alert("Purchase Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Something went wrong. Please try again.")
        }
        .onChange(of: premiumManager.isPremium) { isPremium in
            if isPremium { dismiss() }
        }
    }

    @ViewBuilder
    private func featureBullet(icon: String, text: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CupsTheme.primaryAccent)
                .frame(width: 24)
            Text(text)
                .font(CupsTheme.bodyFont(15))
                .foregroundColor(CupsTheme.textPrimary)
        }
    }

    private func handlePurchase() async {
        do {
            try await premiumManager.purchase()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    private func handleRestore() async {
        do {
            try await premiumManager.restore()
            if !premiumManager.isPremium {
                errorMessage = "No previous purchase found for this Apple ID."
                showError = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
