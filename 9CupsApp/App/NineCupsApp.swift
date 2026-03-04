import SwiftUI

@main
struct NineCupsApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isOnboarding = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !hasCompletedOnboarding && isOnboarding {
                    OnboardingView(isOnboarding: $isOnboarding)
                        .environmentObject(appState)
                        .transition(.opacity)
                        .onChange(of: isOnboarding) { _, newValue in
                            if !newValue {
                                hasCompletedOnboarding = true
                            }
                        }
                } else {
                    MainTabView()
                        .environmentObject(appState)
                        .environment(\.managedObjectContext, appState.persistence.viewContext)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: isOnboarding)
            .preferredColorScheme(.dark)
        }
    }
}
