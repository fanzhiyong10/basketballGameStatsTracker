//
//  Persistence.swift
//  Shared
//
//  Created by 范志勇 on 2022/11/18.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // 预览使用数据
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // 队员
        let player = Player(context: viewContext)
        player.fullName = "Full Test Player"
        player.fullName = "Test Player"

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    // 测试数据
    static var testData: [Player]? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        return try? PersistenceController.preview.container.viewContext.fetch(fetchRequest) as? [Player]
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "basketballGameStatsTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
