import CoreData

enum CupsDataModel {
    static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // MARK: - DailyLog Entity
        let dailyLog = NSEntityDescription()
        dailyLog.name = "CDDailyLog"
        dailyLog.managedObjectClassName = "CDDailyLog"
        dailyLog.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("date", .dateAttributeType, optional: false),
            attribute("leafyGreens", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("redPurple", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("orangeYellow", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("blueBlack", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("sulfurRich", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("proteinOz", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("seaweed", .booleanAttributeType, defaultValue: false),
            attribute("fermented", .booleanAttributeType, defaultValue: false),
            attribute("organMeatOz", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("score", .integer16AttributeType, defaultValue: Int16(0)),
        ]

        // MARK: - UserSettings Entity
        let userSettings = NSEntityDescription()
        userSettings.name = "CDUserSettings"
        userSettings.managedObjectClassName = "CDUserSettings"
        userSettings.properties = [
            attribute("id", .UUIDAttributeType, optional: false),
            attribute("displayName", .stringAttributeType, optional: true),
            attribute("level", .integer16AttributeType, defaultValue: Int16(1)),
            attribute("streakCount", .integer16AttributeType, defaultValue: Int16(0)),
            attribute("lastLogDate", .dateAttributeType, optional: true),
        ]

        model.entities = [dailyLog, userSettings]
        return model
    }

    // MARK: - Helpers

    private static func attribute(
        _ name: String,
        _ type: NSAttributeType,
        optional: Bool = true,
        defaultValue: Any? = nil
    ) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = optional
        if let dv = defaultValue {
            attr.defaultValue = dv
        }
        return attr
    }
}
