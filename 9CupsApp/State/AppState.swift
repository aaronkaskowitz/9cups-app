import CoreData
import SwiftUI

class AppState: ObservableObject {
    let persistence: PersistenceController

    @Published var settings: CDUserSettings?
    @Published var todayLog: CDDailyLog?

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
        loadData()
    }

    func loadData() {
        settings = persistence.getOrCreateSettings()
        todayLog = persistence.getOrCreateTodayLog()
    }

    func save() {
        if let log = todayLog, let settings = settings {
            log.score = log.calculateScore(proteinTarget: settings.proteinTarget)
        }
        persistence.save()
        objectWillChange.send()
    }

    // MARK: - Quick Add

    func addLeafyGreen() {
        let log = ensureTodayLog()
        if log.leafyGreens < 9 { log.leafyGreens += 1 }
        save()
        updateStreak()
    }

    func addRedPurple() {
        let log = ensureTodayLog()
        if log.redPurple < 9 { log.redPurple += 1 }
        save()
        updateStreak()
    }

    func addOrangeYellow() {
        let log = ensureTodayLog()
        if log.orangeYellow < 9 { log.orangeYellow += 1 }
        save()
        updateStreak()
    }

    func addBlueBlack() {
        let log = ensureTodayLog()
        if log.blueBlack < 9 { log.blueBlack += 1 }
        save()
        updateStreak()
    }

    func addSulfurRich() {
        let log = ensureTodayLog()
        if log.sulfurRich < 9 { log.sulfurRich += 1 }
        save()
        updateStreak()
    }

    func addProtein(oz: Int16 = 4) {
        let log = ensureTodayLog()
        log.proteinOz = min(log.proteinOz + oz, 24)
        save()
        updateStreak()
    }

    func toggleSeaweed() {
        let log = ensureTodayLog()
        log.seaweed.toggle()
        save()
        updateStreak()
    }

    func toggleFermented() {
        let log = ensureTodayLog()
        log.fermented.toggle()
        save()
        updateStreak()
    }

    func addOrganMeat(oz: Int16 = 4) {
        let log = ensureTodayLog()
        log.organMeatOz = min(log.organMeatOz + oz, 24)
        save()
        updateStreak()
    }

    func decrementLeafyGreen() {
        let log = ensureTodayLog()
        if log.leafyGreens > 0 { log.leafyGreens -= 1 }
        save()
    }

    func decrementRedPurple() {
        let log = ensureTodayLog()
        if log.redPurple > 0 { log.redPurple -= 1 }
        save()
    }

    func decrementOrangeYellow() {
        let log = ensureTodayLog()
        if log.orangeYellow > 0 { log.orangeYellow -= 1 }
        save()
    }

    func decrementBlueBlack() {
        let log = ensureTodayLog()
        if log.blueBlack > 0 { log.blueBlack -= 1 }
        save()
    }

    func decrementSulfurRich() {
        let log = ensureTodayLog()
        if log.sulfurRich > 0 { log.sulfurRich -= 1 }
        save()
    }

    func decrementProtein() {
        let log = ensureTodayLog()
        if log.proteinOz > 0 { log.proteinOz -= 1 }
        save()
    }

    func decrementOrganMeat() {
        let log = ensureTodayLog()
        if log.organMeatOz > 0 { log.organMeatOz -= 1 }
        save()
    }

    // MARK: - Settings

    func updateLevel(_ newLevel: Int16) {
        let s = ensureSettings()
        s.level = newLevel
        save()
    }

    func updateDisplayName(_ name: String) {
        let s = ensureSettings()
        s.displayName = name
        save()
    }

    // MARK: - Streak

    func updateStreak() {
        let s = ensureSettings()
        let log = ensureTodayLog()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        log.score = log.calculateScore(proteinTarget: s.proteinTarget)

        if let lastDate = s.lastLogDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            if lastDay == today {
                return
            }
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            if lastDay == yesterday && log.score >= 70 {
                s.streakCount += 1
            } else if lastDay != yesterday {
                s.streakCount = log.score >= 70 ? 1 : 0
            }
        } else {
            s.streakCount = log.score >= 70 ? 1 : 0
        }

        s.lastLogDate = Date()
        persistence.save()
    }

    // MARK: - Weekly Data

    var weeklyOrganMeatOz: Int {
        let logs = persistence.fetchLogs(days: 7)
        return logs.reduce(0) { $0 + Int($1.organMeatOz) }
    }
    func weeklyLogs() -> [CDDailyLog] {
        persistence.fetchLogs(days: 7)
    }

    // MARK: - Reset

    func resetAllData() {
        persistence.deleteAllLogs()
        if let s = settings {
            s.streakCount = 0
            s.lastLogDate = nil
        }
        persistence.save()
        todayLog = nil
        loadData()
    }

    // MARK: - Date Rollover

    func checkDateRollover() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let log = todayLog {
            let logDay = calendar.startOfDay(for: log.date)
            if logDay != today {
                todayLog = persistence.getOrCreateTodayLog()
            }
        }
    }

    // MARK: - Helpers

    private func ensureTodayLog() -> CDDailyLog {
        if let log = todayLog { return log }
        let log = persistence.getOrCreateTodayLog()
        todayLog = log
        return log
    }

    private func ensureSettings() -> CDUserSettings {
        if let s = settings { return s }
        let s = persistence.getOrCreateSettings()
        settings = s
        return s
    }

    var currentLevel: Int {
        Int(settings?.level ?? 1)
    }

    var proteinTarget: Int {
        settings?.proteinTarget ?? 6
    }

    var streakCount: Int {
        Int(settings?.streakCount ?? 0)
    }

    var todayScore: Int {
        Int(todayLog?.score ?? 0)
    }

    var totalCups: Int {
        todayLog?.totalCups ?? 0
    }

    var cupsFraction: Double {
        min(Double(totalCups) / 9.0, 1.0)
    }
}
