import SwiftUI

struct WeeklySummaryView: View {
    @EnvironmentObject var appState: AppState

    private var logs: [CDDailyLog] {
        appState.weeklyLogs()
    }

    private var last7Days: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).reversed().map { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)!
        }
    }

    private func logForDate(_ date: Date) -> CDDailyLog? {
        let calendar = Calendar.current
        return logs.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(CupsTheme.headerFont(18))
                .foregroundColor(CupsTheme.textPrimary)

            HStack(spacing: 8) {
                ForEach(last7Days, id: \.self) { date in
                    let log = logForDate(date)
                    let score = Int(log?.score ?? 0)
                    let isToday = Calendar.current.isDateInToday(date)

                    VStack(spacing: 6) {
                        Text(dayLabel(date))
                            .font(CupsTheme.bodyFont(11))
                            .foregroundColor(isToday ? CupsTheme.primaryAccent : CupsTheme.textSecondary)

                        ZStack {
                            Circle()
                                .fill(colorForScore(score, hasLog: log != nil))
                                .frame(width: 36, height: 36)

                            if log != nil {
                                Text("\(score)")
                                    .font(CupsTheme.labelFont(11))
                                    .foregroundColor(score >= 70 ? .black : CupsTheme.textPrimary)
                            }
                        }

                        if isToday {
                            Circle()
                                .fill(CupsTheme.primaryAccent)
                                .frame(width: 4, height: 4)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(dayLabel(date)): \(log != nil ? "\(score) percent" : "no data")")
                }
            }
        }
        .cupsCard()
        .padding(.horizontal, 16)
    }

    private func colorForScore(_ score: Int, hasLog: Bool) -> Color {
        guard hasLog else { return CupsTheme.background }
        if score >= 70 {
            return CupsTheme.primaryAccent
        } else if score >= 40 {
            return CupsTheme.secondaryAccent.opacity(0.6)
        } else {
            return CupsTheme.cardBackground.opacity(0.8)
        }
    }
}
