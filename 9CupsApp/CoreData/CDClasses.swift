import CoreData
import Foundation

// MARK: - CDDailyLog

@objc(CDDailyLog)
class CDDailyLog: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var leafyGreens: Int16
    @NSManaged var redPurple: Int16
    @NSManaged var orangeYellow: Int16
    @NSManaged var blueBlack: Int16
    @NSManaged var sulfurRich: Int16
    @NSManaged var proteinOz: Int16
    @NSManaged var seaweed: Bool
    @NSManaged var fermented: Bool
    @NSManaged var organMeatOz: Int16
    @NSManaged var score: Int16

    var totalCups: Int {
        min(Int(leafyGreens), 3) + min(Int(redPurple) + Int(orangeYellow) + Int(blueBlack), 3) + min(Int(sulfurRich), 3)
    }

    var coloredTotal: Int {
        Int(redPurple) + Int(orangeYellow) + Int(blueBlack)
    }

    var colorsEaten: Int {
        var count = 0
        if redPurple > 0 { count += 1 }
        if orangeYellow > 0 { count += 1 }
        if blueBlack > 0 { count += 1 }
        return count
    }

    func calculateScore(proteinTarget: Int) -> Int16 {
        let leafyRatio = min(Double(leafyGreens) / 3.0, 1.0)
        let colorRatio = min(Double(redPurple + orangeYellow + blueBlack) / 3.0, 1.0)
        let sulfurRatio = min(Double(sulfurRich) / 3.0, 1.0)
        let proteinRatio = proteinTarget > 0 ? min(Double(proteinOz) / Double(proteinTarget), 1.0) : 0
        let seaweedRatio: Double = seaweed ? 1.0 : 0.0
        let fermentedRatio: Double = fermented ? 1.0 : 0.0

        let average = (leafyRatio + colorRatio + sulfurRatio + proteinRatio + seaweedRatio + fermentedRatio) / 6.0
        return Int16(average * 100)
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - CDUserSettings

@objc(CDUserSettings)
class CDUserSettings: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var displayName: String?
    @NSManaged var level: Int16
    @NSManaged var streakCount: Int16
    @NSManaged var lastLogDate: Date?

    var proteinTarget: Int {
        switch level {
        case 1: return 6
        case 2: return 9
        case 3: return 12
        default: return 6
        }
    }

    var greeting: String {
        if let name = displayName, !name.isEmpty {
            return name
        }
        return "there"
    }
}
