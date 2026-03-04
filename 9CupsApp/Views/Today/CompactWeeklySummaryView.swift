import SwiftUI

struct CompactWeeklySummaryView: View {
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

    private func dayInitial(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(last7Days, id: \.self) { date in
                let log = logForDate(date)
                let score = Int(log?.score ?? 0)
                let isToday = Calendar.current.isDateInToday(date)

                VStack(spacing: 4) {
                    Text(dayInitial(date))
                        .font(CupsTheme.bodyFont(10))
                        .foregroundColor(isToday ? CupsTheme.primaryAccent : CupsTheme.textSecondary)

                    Circle()
                        .fill(dotColor(score: score, hasLog: log != nil))
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(isToday ? CupsTheme.primaryAccent : Color.clear, lineWidth: 1.5)
                                .frame(width: 16, height: 16)
                        )
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(dayInitial(date)): \(log != nil ? "\(score) percent" : "no data")")
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(CupsTheme.cardBackground)
        .cornerRadius(CupsTheme.cornerRadiusSmall)
        .padding(.horizontal, 16)
    }

    private func dotColor(score: Int, hasLog: Bool) -> Color {
        guard hasLog else { return CupsTheme.background }
        if score >= 70 {
            return CupsTheme.primaryAccent
        } else if score >= 40 {
            return CupsTheme.secondaryAccent.opacity(0.6)
        } else {
            return CupsTheme.textSecondary.opacity(0.3)
        }
    }
}
