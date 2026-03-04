import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var displayName: String = ""
    @State private var selectedLevel: Int = 1
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Profile")
                        .font(CupsTheme.headerFont(28))
                        .foregroundColor(CupsTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    // Display Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Name")
                            .font(CupsTheme.labelFont(14))
                            .foregroundColor(CupsTheme.textSecondary)

                        TextField("Enter your name", text: $displayName)
                            .font(CupsTheme.bodyFont(16))
                            .foregroundColor(CupsTheme.textPrimary)
                            .padding(12)
                            .background(CupsTheme.background)
                            .cornerRadius(CupsTheme.cornerRadiusSmall)
                            .onChange(of: displayName) { _, newValue in
                                appState.updateDisplayName(newValue)
                            }
                            .accessibilityLabel("Display name")
                    }
                    .cupsCard()
                    .padding(.horizontal, 16)

                    // Level Selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Protocol Level")
                            .font(CupsTheme.labelFont(14))
                            .foregroundColor(CupsTheme.textSecondary)

                        Picker("Level", selection: $selectedLevel) {
                            Text("Level 1").tag(1)
                            Text("Level 2").tag(2)
                            Text("Level 3").tag(3)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedLevel) { _, newValue in
                            appState.updateLevel(Int16(newValue))
                        }

                        if let level = NineCupsProtocol.levels.first(where: { $0.id == selectedLevel }) {
                            Text(level.name)
                                .font(CupsTheme.labelFont(13))
                                .foregroundColor(CupsTheme.primaryAccent)
                        }
                    }
                    .cupsCard()
                    .padding(.horizontal, 16)

                    // Weekly Summary
                    WeeklySummaryView()
                        .environmentObject(appState)

                    // About
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(CupsTheme.headerFont(18))
                            .foregroundColor(CupsTheme.textPrimary)

                        Text("9 Cups helps you track the Wahls Protocol\u{2019}s daily nutrition targets. This app is not a substitute for medical advice.")
                            .font(CupsTheme.bodyFont(14))
                            .foregroundColor(CupsTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Version 1.0")
                            .font(CupsTheme.bodyFont(13))
                            .foregroundColor(CupsTheme.textSecondary.opacity(0.6))
                    }
                    .cupsCard()
                    .padding(.horizontal, 16)

                    // Reset Data
                    Button(action: { showResetConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Reset All Data")
                        }
                        .font(CupsTheme.labelFont(15))
                        .foregroundColor(.red.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(CupsTheme.cardBackground)
                        .cornerRadius(CupsTheme.cornerRadius)
                    }
                    .padding(.horizontal, 16)
                    .frame(minHeight: 48)
                    .accessibilityLabel("Reset all tracking data")
                    .alert("Reset All Data?", isPresented: $showResetConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Reset", role: .destructive) {
                            appState.resetAllData()
                        }
                    } message: {
                        Text("This will delete all your tracking history and reset your streak. This cannot be undone.")
                    }

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
            .background(CupsTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            displayName = appState.settings?.displayName ?? ""
            selectedLevel = appState.currentLevel
        }
    }
}
