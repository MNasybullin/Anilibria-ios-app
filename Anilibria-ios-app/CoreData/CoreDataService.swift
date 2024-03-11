//
//  CoreDataService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.11.2023.
//

import Foundation
import CoreData
import OSLog

final class CoreDataService {
    static let shared = CoreDataService()
    private let logger = Logger(subsystem: .coreData, category: .empty)
    
    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Anilibria-ios-app")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                self.logger.error("\(Logger.logInfo(error: error)) Unresolved error \(error, privacy: .auto), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = persistantContainer.viewContext
    
    private init() {
        UIImageTransformer.register()
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            logger.error("\(Logger.logInfo(error: error)) Unresolved error \(error), \(error.userInfo)")
        }
    }
}
