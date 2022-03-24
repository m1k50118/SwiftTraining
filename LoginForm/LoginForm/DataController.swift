//
//  DataController.swift
//  LoginForm
//
//  Created by 佐藤真 on 2021/01/07.
//

import UIKit
import CoreData

class DataController: NSObject {
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let contaienr = NSPersistentContainer(name: "TestCoreData")
        contaienr.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to persistent stores:\(error)")
            }
        }
        return contaienr
    }()
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? persistentContainer.viewContext
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        
    }
}
