//
//  UserEntity+CoreDataProperties.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.01.2024.
//
//

import Foundation
import CoreData
import UIKit

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String
    @NSManaged public var image: UIImage
    @NSManaged public var imageUrl: String
    @NSManaged public var login: String
    @NSManaged public var nickname: String?
    @NSManaged public var patreonId: String?
    @NSManaged public var vkId: String?
    @NSManaged public var watching: NSSet?

}

// MARK: Generated accessors for watching
extension UserEntity {

    @objc(addWatchingObject:)
    @NSManaged public func addToWatching(_ value: WatchingEntity)

    @objc(removeWatchingObject:)
    @NSManaged public func removeFromWatching(_ value: WatchingEntity)

    @objc(addWatching:)
    @NSManaged public func addToWatching(_ values: NSSet)

    @objc(removeWatching:)
    @NSManaged public func removeFromWatching(_ values: NSSet)

}

extension UserEntity: Identifiable {

}
