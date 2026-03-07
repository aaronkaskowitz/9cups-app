import SwiftUI

struct GuideView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedLevel: Int = 1

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Protocol Guide")
                        .font(CupsTheme.headerFont(24))
                        .foregroundColor(CupsTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    // Level Selector
                    Picker("Level", selection: $selectedLevel) {
                        Text("Level 1").tag(1)
                        Text("Level 2").tag(2)
                        Text("Level 3").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .accessibilityLabel("Protocol level selector")

                    // Level Detail
                    if let level = NineCupsProtocol.levels.first(where: { $0.id == selectedLevel }) {
                        LevelDetailView(level: level)
                    }

                    // Food Reference
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Food Reference")
                            .font(CupsTheme.headerFont(20))
                            .foregroundColor(CupsTheme.textPrimary)
                            .padding(.horizontal, 16)

                        ForEach(FoodDatabase.allCategories) { category in
                            FoodListView(category: category)
                        }
                    }

                    // Meal Timing
                    mealTimingSection

                    // FAQ
                    faqSection

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
            .background(CupsTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            selectedLevel = appState.currentLevel
        }
    }

    private var mealTimingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal Timing")
                .font(CupsTheme.headerFont(20))
                .foregroundColor(CupsTheme.textPrimary)
                .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 10) {
                if selectedLevel <= 2 {
                    timingRow(title: "Meals per day", value: "3")
                    timingRow(title: "Fasting window", value: "12 hours overnight")
                    timingRow(title: "Eating window", value: "7:00 AM \u{2013} 7:00 PM")
                } else {
                    timingRow(title: "Meals per day", value: "2")
                    timingRow(title: "Fasting window", value: "16 hours")
                    timingRow(title: "Eating window", value: "11:00 AM \u{2013} 7:00 PM")
                }

                timelineView
            }
            .padding(16)
            .background(CupsTheme.cardBackground)
            .cornerRadius(CupsTheme.cornerRadius)
            .padding(.horizontal, 16)
        }
    }

    private func timingRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(CupsTheme.bodyFont(14))
                .foregroundColor(CupsTheme.textSecondary)
            Spacer()
            Text(value)
                .font(CupsTheme.labelFont(14))
                .foregroundColor(CupsTheme.textPrimary)
        }
        .accessibilityElement(children: .combine)
    }

    private var timelineView: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let startHour: Double = selectedLevel <= 2 ? 7 : 11
            let endHour: Double = 19

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(CupsTheme.background)
                    .frame(height: 12)

                Capsule()
                    .fill(CupsTheme.primaryAccent.opacity(0.6))
                    .frame(
                        width: totalWidth * CGFloat((endHour - startHour) / 24.0),
                        height: 12
                    )
                    .offset(x: totalWidth * CGFloat(startHour / 24.0))
            }
        }
        .frame(height: 12)
        .padding(.top, 8)
        .accessibilityLabel("Timeline showing eating window from \(selectedLevel <= 2 ? "7 AM" : "11 AM") to 7 PM")
    }

    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Common Questions")
                .font(CupsTheme.headerFont(20))
                .foregroundColor(CupsTheme.textPrimary)
                .padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 16) {
                faqItem(
                    question: "Do fruits count?",
                    answer: "Yes! Fruits are a big part of the colored produce categories. Blueberries, cherries, mango, blackberries, pomegranate, figs — these all count toward your colored cups. The rule is the same: the fruit should be colored all the way through. Strawberries, raspberries, and citrus fruits all qualify. Apples and bananas do not (white inside)."
                )

                faqItem(
                    question: "What counts as 1 cup?",
                    answer: "1 cup is about the size of your closed fist, or a standard measuring cup (8 oz by volume). For raw leafy greens like spinach or kale, 1 cup is a loose handful. For denser vegetables like broccoli or beets, pack it lightly into a measuring cup. When in doubt, a fist-sized portion is close enough."
                )

                faqItem(
                    question: "Do I measure raw or cooked?",
                    answer: "Measure raw when possible. Cooking shrinks vegetables significantly, so 1 cup of raw spinach cooks down to much less. If you only have cooked veggies, roughly half a cup cooked equals 1 cup raw."
                )

                faqItem(
                    question: "Does it have to be exact?",
                    answer: "No. This is a daily target to aim for, not a precise prescription. Getting close to 9 cups matters way more than measuring perfectly. Your fist is a good enough scoop."
                )

                faqItem(
                    question: "What does \"colored all the way through\" mean?",
                    answer: "For the color categories, the vegetable or fruit should be colored on the inside, not just the skin. A red apple doesn't count (white inside), but a beet does (red all the way through). Think: blueberries, sweet potatoes, purple cabbage, carrots, watermelon."
                )
            }
            .padding(16)
            .background(CupsTheme.cardBackground)
            .cornerRadius(CupsTheme.cornerRadius)
            .padding(.horizontal, 16)
        }
    }

    private func faqItem(question: String, answer: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(question)
                .font(CupsTheme.labelFont(15))
                .foregroundColor(CupsTheme.primaryAccent)
            Text(answer)
                .font(CupsTheme.bodyFont(14))
                .foregroundColor(CupsTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}
