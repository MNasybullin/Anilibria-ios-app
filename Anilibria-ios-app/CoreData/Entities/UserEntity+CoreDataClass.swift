//
//  UserEntity+CoreDataClass.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.12.2023.
//
//

import Foundation
import CoreData

public class UserEntity: NSManagedObject {
    static private func fetchUsers(userId: Int, context: NSManagedObjectContext) throws -> [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", userId)
        
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
    
    static func find(userId: Int, context: NSManagedObjectContext) throws -> UserEntity {
        do {
            let fetchResult = try fetchUsers(userId: userId, context: context)
            if let user = fetchResult.first {
                return user
            } else {
                throw NSError(domain: "No user data in coreData", code: 404)
            }
        } catch {
            throw error
        }
    }
    
    static func updateOrCreate(user: UserItem, context: NSManagedObjectContext) throws {
        do {
            let users = try fetchUsers(userId: user.id, context: context)
            if let existingUser = users.first {
                existingUser.id = Int64(user.id)
                existingUser.name = user.name
                existingUser.image = user.image ?? Asset.Assets.noAvatar.image
                existingUser.imageUrl = user.imageUrl
            } else {
                let newUser = UserEntity(context: context)
                newUser.id = Int64(user.id)
                newUser.name = user.name
                newUser.image = user.image ?? Asset.Assets.noAvatar.image
                newUser.imageUrl = user.imageUrl
            }
            try context.save()
        } catch {
            throw error
        }
    }
}
