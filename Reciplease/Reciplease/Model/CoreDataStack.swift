//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by damien on 01/08/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared: CoreDataStack = CoreDataStack()
    
    public static let modelName = "Reciplease"
    
    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        print(container.persistentStoreDescriptions.first?.url as Any)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func derivedContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
      return context
    }
}
