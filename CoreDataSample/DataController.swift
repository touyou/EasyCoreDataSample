//
//  DataController.swift
//  CoreDataSample
//
//  Created by 藤井陽介 on 2019/03/22.
//  Copyright © 2019 touyou. All rights reserved.
//

import UIKit
import CoreData

class DataController {

    static let shared: DataController = DataController()

    private var persistentController: NSPersistentContainer!

    init() {

        persistentController = NSPersistentContainer(name: "CoreDataSample")
        persistentController.loadPersistentStores { (description, error) in

            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }

            print(description)
        }
    }

    func create<T: NSManagedObject>() -> T {

        let context = persistentController.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
        return object
    }

    func saveContext() {

        let context = persistentController.viewContext

        do {

            try context.save()
        } catch {

            print("Failed save context: \(error)")
        }
    }

    func getFetchedResultController<T: NSManagedObject>(with descriptor: [String] = []) -> NSFetchedResultsController<T> {

        let context = persistentController.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = descriptor.map { NSSortDescriptor(key: $0, ascending: true) }
        return NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
}
