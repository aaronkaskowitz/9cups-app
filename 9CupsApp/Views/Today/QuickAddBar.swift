import SwiftUI

struct QuickAddBar: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                quickButton(label: "+1 Leafy", emoji: "\u{1F96C}") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    appState.addLeafyGreen()
                }
                quickButton(label: "+1 Red", emoji: "\u{1F3A8}") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    appState.addRedPurple()
                }
                quickButton(label: "+1 Sulfur", emoji: "\u{1F9C4}") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    appState.addSulfurRich()
                }
                quickButton(label: "+4oz Protein", emoji: "\u{1F969}") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    appState.addProtein(oz: 4)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func quickButton(label: String, emoji: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.system(size: 16))
                Text(label)
                    .font(CupsTheme.labelFont(13))
                    .foregroundColor(CupsTheme.textPrimary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(CupsTheme.cardBackground)
            .cornerRadius(CupsTheme.cornerRadiusSmall)
            .overlay(
                RoundedRectangle(cornerRadius: CupsTheme.cornerRadiusSmall)
                    .stroke(CupsTheme.primaryAccent.opacity(0.3), lineWidth: 1)
            )
        }
        .frame(minHeight: 48)
        .accessibilityLabel(label)
        .accessibilityHint("Double tap to add one serving")
    }
}
