//
//  EpisodesEntity+CoreDataClass.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.12.2023.
//
//

import Foundation
import CoreData
import UIKit

public class EpisodesEntity: NSManagedObject {
    static func create(forWatching watching: WatchingEntity,
                       context: NSManagedObjectContext,
                       duration: Double, 
                       playbackPosition: Double,
                       numberOfEpisode: Float?,
                       image: UIImage?) -> EpisodesEntity {
        let episodeEntity = EpisodesEntity(context: context)
        episodeEntity.duration = duration
        episodeEntity.numberOfEpisode = numberOfEpisode ?? 0
        episodeEntity.playbackPosition = playbackPosition
        episodeEntity.watchingDate = Date()
        episodeEntity.watching = watching
        episodeEntity.watching?.animeImage = image
        return episodeEntity
    }
}
