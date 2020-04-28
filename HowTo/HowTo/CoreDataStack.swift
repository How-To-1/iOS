//
//  Tutorials.swift
//  HowTo
//
//  Created by Dahna on 4/28/20.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tutorials")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataTask.shared.mainContext) {
      context.performAndWait {
        do {
          try context.save()
        } catch {
          NSLog("Error saving to persistent stores: \(error)")
          context.reset()
        }
      }
    }
}
