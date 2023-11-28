//
//  UserEntity.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.11.2023.
//

import Foundation
import CoreData

// Unique Entity
class UserEntity: NSManagedObject {
    
    static private func fetchUsers(context: NSManagedObjectContext) throws -> [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in CoreData!")
            }
            return fetchResult
        } catch {
            throw error
        }
    }
    
    static func get(context: NSManagedObjectContext) throws -> UserEntity {
        do {
            let users = try fetchUsers(context: context)
            if let user = users.first {
                return user
            } else {
                throw NSError(domain: "No user data", code: 404)
            }
        } catch {
            throw error
        }
    }
    
    static func create(user: UserItem, context: NSManagedObjectContext) throws {
        do {
            let users = try fetchUsers(context: context)
            if let existingUser = users.first {
                existingUser.id = Int64(user.id)
                existingUser.name = user.name
                existingUser.image = user.image?.pngData()
                existingUser.imageUrl = user.imageUrl
            } else {
                let newUser = UserEntity(context: context)
                newUser.id = Int64(user.id)
                newUser.name = user.name
                newUser.image = user.image?.pngData()
                newUser.imageUrl = user.imageUrl
            }
            try context.save()
        } catch {
            throw error
        }
    }
}
