import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let name = appState.settings?.greeting ?? "there"
        switch hour {
        case 5..<12: return "Good morning, \(name)"
        case 12..<17: return "Good afternoon, \(name)"
        case 17..<22: return "Good evening, \(name)"
        default: return "Still up, \(name)?"
        }
    }

    @State private var previousTotalCups = 0

    private var log: CDDailyLog? { appState.todayLog }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Greeting
                    Text(greeting)
                        .font(CupsTheme.headerFont(24))
                        .foregroundColor(CupsTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    // Streak
                    if appState.streakCount > 0 {
                        HStack(spacing: 6) {
                            Text("\u{1F525}")
                            Text("\(appState.streakCount) day streak")
                                .font(CupsTheme.labelFont(15))
                                .foregroundColor(CupsTheme.secondaryAccent)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .accessibilityLabel("\(appState.streakCount) day streak")
                    }

                    // Compact Weekly Summary
                    CompactWeeklySummaryView()
                        .environmentObject(appState)

                    // Color Ring
                    ColorRingView(
                        leafyGreens: Int(log?.leafyGreens ?? 0),
                        redPurple: Int(log?.redPurple ?? 0),
                        orangeYellow: Int(log?.orangeYellow ?? 0),
                        blueBlack: Int(log?.blueBlack ?? 0),
                        sulfurRich: Int(log?.sulfurRich ?? 0),
                        totalCups: appState.totalCups,
                        isComplete: appState.totalCups >= 9,
                        seaweed: log?.seaweed ?? false,
                        fermented: log?.fermented ?? false
                    )
                    .padding(.vertical, 8)

                    // Score
                    Text("\(appState.todayScore)% daily score")
                        .font(CupsTheme.labelFont(14))
                        .foregroundColor(CupsTheme.textSecondary)


                    // Category Cards
                    VStack(spacing: 12) {
                        CategoryCardView(
                            emoji: "\u{1F96C}",
                            name: "Leafy Greens",
                            current: Int(log?.leafyGreens ?? 0),
                            target: 3,
                            onIncrement: { appState.addLeafyGreen() },
                            onDecrement: { appState.decrementLeafyGreen() }
                        )

                        // Colored Produce Section Header
                        Text("🌈 Colored Produce — 3 cups total, aim for all 3 colors")
                            .font(CupsTheme.labelFont(13))
                            .foregroundColor(CupsTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        VStack(spacing: 12) {
                            CategoryCardView(
                                emoji: "\u{1F534}",
                                name: "Red & Purple",
                                current: Int(log?.redPurple ?? 0),
                                target: 1,
                                unit: "cups",
                                onIncrement: { appState.addRedPurple() },
                                onDecrement: { appState.decrementRedPurple() }
                            )

                            CategoryCardView(
                                emoji: "\u{1F7E0}",
                                name: "Orange & Yellow",
                                current: Int(log?.orangeYellow ?? 0),
                                target: 1,
                                unit: "cups",
                                onIncrement: { appState.addOrangeYellow() },
                                onDecrement: { appState.decrementOrangeYellow() }
                            )

                            CategoryCardView(
                                emoji: "\u{1F535}",
                                name: "Blue & Black",
                                current: Int(log?.blueBlack ?? 0),
                                target: 1,
                                unit: "cups",
                                onIncrement: { appState.addBlueBlack() },
                                onDecrement: { appState.decrementBlueBlack() }
                            )
                        }
                        .padding(.leading, 12)

                        CategoryCardView(
                            emoji: "\u{1F9C4}",
                            name: "Sulfur-Rich",
                            current: Int(log?.sulfurRich ?? 0),
                            target: 3,
                            onIncrement: { appState.addSulfurRich() },
                            onDecrement: { appState.decrementSulfurRich() }
                        )

                        CategoryCardView(
                            emoji: "\u{1F969}",
                            name: "Protein",
                            current: Int(log?.proteinOz ?? 0),
                            target: appState.proteinTarget,
                            unit: "oz",
                            onIncrement: { appState.addProtein(oz: 1) },
                            onDecrement: { appState.decrementProtein() }
                        )

                        CategoryCardView(
                            emoji: "\u{1F30A}",
                            name: "Seaweed",
                            current: 0,
                            target: 1,
                            isCheckbox: true,
                            isChecked: log?.seaweed ?? false,
                            onIncrement: { appState.toggleSeaweed() }
                        )

                        CategoryCardView(
                            emoji: "\u{1FAD9}",
                            name: "Fermented",
                            current: 0,
                            target: 1,
                            isCheckbox: true,
                            isChecked: log?.fermented ?? false,
                            onIncrement: { appState.toggleFermented() }
                        )

                        CategoryCardView(
                            emoji: "\u{1FAC0}",
                            name: "Organ Meat",
                            current: appState.weeklyOrganMeatOz,
                            target: 12,
                            unit: "oz/week",
                            onIncrement: { appState.addOrganMeat(oz: 1) },
                            onDecrement: { appState.decrementOrganMeat() }
                        )
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
            .background(CupsTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onChange(of: appState.totalCups) { _, newValue in
            if newValue >= 9 && previousTotalCups < 9 {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            previousTotalCups = newValue
        }
        .onAppear {
            previousTotalCups = appState.totalCups
        }
    }
}
