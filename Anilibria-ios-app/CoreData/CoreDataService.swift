//
//  CoreDataService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.11.2023.
//

import Foundation
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    
    lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Anilibria-ios-app")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = persistantContainer.viewContext
    
    private init() {
        
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
