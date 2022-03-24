//
//  UserModel.swift
//  LoginForm
//
//  Created by 佐藤真 on 2021/01/06.
//

import Foundation
import CoreData

protocol UserModelInput {
    func registerUser(name: String, userId: String, password: String)
    func fetchUser(with predicate: NSPredicate?) -> [User]
    func findUser(userId: String, password: String) -> [User]
}

final class UserModel: UserModelInput {
    private let moContext: NSManagedObjectContext
    
    init(moContext: NSManagedObjectContext) {
        self.moContext = moContext
    }
    
    func registerUser(name: String, userId: String, password: String) {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: moContext) as! User
        user.name = name
        user.userId = userId
        user.password = password
        
        if moContext.hasChanges {
            do {
                try moContext.save()
            } catch let error as NSError {
                print("Core Data Error:\(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchUser(with predicate: NSPredicate?) -> [User] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = predicate
        
        do {
            let user = try moContext.fetch(request) as! [User]
            return user
        } catch let error as NSError {
            print("Core Data Error:\(error), \(error.userInfo)")
            fatalError()
        }
    }
    
    func findUser(userId: String, password: String) -> [User] {
        let predicate = NSPredicate(format: "userId == %@ and password == %@", userId, password)
        
        return fetchUser(with: predicate)
    }
}
