import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                TodayView()
                    .environmentObject(appState)
                    .tag(0)

                GuideView()
                    .environmentObject(appState)
                    .tag(1)

                ProfileView()
                    .environmentObject(appState)
                    .tag(2)
            }

            // Custom tab bar
            HStack(spacing: 0) {
                tabButton(icon: "leaf.fill", label: "Today", tag: 0)
                tabButton(icon: "book.fill", label: "Guide", tag: 1)
                tabButton(icon: "person.fill", label: "Profile", tag: 2)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .cornerRadius(CupsTheme.cornerRadiusLarge)
            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: -2)
            .padding(.horizontal, 40)
            .padding(.bottom, 2)
        }
    }

    private func tabButton(icon: String, label: String, tag: Int) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedTab = tag
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tag ? CupsTheme.primaryAccent : CupsTheme.textSecondary)
                Text(label)
                    .font(CupsTheme.labelFont(11))
                    .foregroundColor(selectedTab == tag ? CupsTheme.primaryAccent : CupsTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 48)
        }
        .accessibilityLabel(label)
        .accessibilityAddTraits(selectedTab == tag ? .isSelected : [])
    }
}
