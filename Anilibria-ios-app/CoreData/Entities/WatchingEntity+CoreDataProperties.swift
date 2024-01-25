//
//  WatchingEntity+CoreDataProperties.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.01.2024.
//
//

import Foundation
import CoreData

extension WatchingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchingEntity> {
        return NSFetchRequest<WatchingEntity>(entityName: "WatchingEntity")
    }

    @NSManaged public var animeId: Int64
    @NSManaged public var episodes: NSSet?
    @NSManaged public var user: UserEntity?

}

// MARK: Generated accessors for episodes
extension WatchingEntity {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: EpisodesEntity)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: EpisodesEntity)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}

extension WatchingEntity: Identifiable {

}
