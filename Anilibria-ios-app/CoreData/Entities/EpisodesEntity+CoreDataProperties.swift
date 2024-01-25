//
//  EpisodesEntity+CoreDataProperties.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.01.2024.
//
//

import Foundation
import CoreData

extension EpisodesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodesEntity> {
        return NSFetchRequest<EpisodesEntity>(entityName: "EpisodesEntity")
    }

    @NSManaged public var duration: Double
    @NSManaged public var numberOfEpisode: Float
    @NSManaged public var playbackPosition: Double
    @NSManaged public var watchingDate: Date
    @NSManaged public var watching: WatchingEntity?

}

extension EpisodesEntity: Identifiable {

}
