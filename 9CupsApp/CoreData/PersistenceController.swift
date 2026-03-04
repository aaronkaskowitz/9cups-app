import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        PersistenceController(inMemory: true)
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = CupsDataModel.createModel()
        container = NSPersistentContainer(name: "CupsModel", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data failed to load: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func save() {
        let context = viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("Core Data save error: \(nsError), \(nsError.userInfo)")
        }
    }

    func fetchSettings() -> CDUserSettings? {
        let request = NSFetchRequest<CDUserSettings>(entityName: "CDUserSettings")
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }

    func getOrCreateSettings() -> CDUserSettings {
        if let existing = fetchSettings() {
            return existing
        }
        let settings = CDUserSettings(context: viewContext)
        settings.id = UUID()
        settings.level = 1
        settings.streakCount = 0
        save()
        return settings
    }

    func fetchTodayLog() -> CDDailyLog? {
        let request = NSFetchRequest<CDDailyLog>(entityName: "CDDailyLog")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }

    func getOrCreateTodayLog() -> CDDailyLog {
        if let existing = fetchTodayLog() {
            return existing
        }
        let log = CDDailyLog(context: viewContext)
        log.id = UUID()
        log.date = Date()
        save()
        return log
    }

    func fetchLogs(days: Int) -> [CDDailyLog] {
        let request = NSFetchRequest<CDDailyLog>(entityName: "CDDailyLog")
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -days, to: calendar.startOfDay(for: Date()))!
        request.predicate = NSPredicate(format: "date >= %@", startDate as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return (try? viewContext.fetch(request)) ?? []
    }

    func deleteAllLogs() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDDailyLog")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        _ = try? viewContext.execute(deleteRequest)
        save()
    }
}
