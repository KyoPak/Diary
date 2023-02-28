//
//  CoreDataService.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation
import CoreData

protocol CoreDataService {
    func saveContext()
    func access(completion: @escaping (NSManagedObjectContext) -> Void)
}

final class DefaultCoreDataService {
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let newBackgroundContext = persistentContainer.newBackgroundContext()
        newBackgroundContext.automaticallyMergesChangesFromParent = true
        return newBackgroundContext
    }()
}

extension DefaultCoreDataService: CoreDataService {
    func saveContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func access(completion: @escaping (NSManagedObjectContext) -> Void) {
        completion(backgroundContext)
    }
}
