//
//  WatchingEntity+CoreDataClass.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.12.2023.
//
//

import Foundation
import CoreData

public class WatchingEntity: NSManagedObject {
    static func find(forUser user: UserEntity, animeId: Int, context: NSManagedObjectContext) throws -> WatchingEntity {
        let request = WatchingEntity.fetchRequest()
        request.predicate = NSPredicate(format: "(%K == %@) AND (%K == %lld)", #keyPath(WatchingEntity.user), user, #keyPath(WatchingEntity.animeId), animeId)
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "WatchingEntity duplicate has been found in CoreData!")
            }
            if let watching = fetchResult.first {
                return watching
            } else {
                throw NSError(domain: "No watchingEntity for userId and animeId in coreData", code: 404)
            }
        } catch {
            throw error
        }
    }
    
    static func create(forUser user: UserEntity, animeItem: AnimeItem, context: NSManagedObjectContext) -> WatchingEntity {
        let watchingEntity = WatchingEntity(context: context)
        watchingEntity.animeId = Int64(animeItem.id)
        watchingEntity.animeName = animeItem.ruName
        watchingEntity.animeImage = animeItem.image
        watchingEntity.user = user
        watchingEntity.isHidden = false
        return watchingEntity
    }
}
