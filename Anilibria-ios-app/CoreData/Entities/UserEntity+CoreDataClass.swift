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
    static private func fetchUsers(userLogin: String, context: NSManagedObjectContext) throws -> [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "login == %@", userLogin)
        
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
    
    static func find(userLogin: String, context: NSManagedObjectContext) throws -> UserEntity {
        do {
            let fetchResult = try fetchUsers(userLogin: userLogin, context: context)
            if let user = fetchResult.first {
                return user
            } else {
                throw NSError(domain: "No user data in coreData", code: 404)
            }
        } catch {
            throw error
        }
    }
    
    static func findOrCreate(user: UserItem, context: NSManagedObjectContext) throws {
        do {
            let users = try fetchUsers(userLogin: user.login, context: context)
            if let existingUser = users.first {
                existingUser.login = user.login
                existingUser.nickname = user.nickname
                existingUser.email = user.email
                existingUser.vkId = user.vkId
                existingUser.patreonId = user.patreonId
                existingUser.image = user.image ?? Asset.Assets.noAvatar.image
                existingUser.imageUrl = user.imageUrl
            } else {
                let newUser = UserEntity(context: context)
                newUser.login = user.login
                newUser.nickname = user.nickname
                newUser.email = user.email
                newUser.vkId = user.vkId
                newUser.patreonId = user.patreonId
                newUser.image = user.image ?? Asset.Assets.noAvatar.image
                newUser.imageUrl = user.imageUrl
            }
            try context.save()
        } catch {
            throw error
        }
    }
}
