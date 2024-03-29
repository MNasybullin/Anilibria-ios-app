//
//  EpisodesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import Foundation
import OSLog

final class EpisodesModel: ImageModel {
    private var animeItem: AnimeItem
    
    // MARK: CoreData Properties
    private let coreDataService = CoreDataService.shared
    private let userDefaults = UserDefaults.standard
    private var watchingEntity: WatchingEntity?
    
    var hasWatchingEntity: Bool {
        return watchingEntity != nil
    }
    
    init(animeItem: AnimeItem) {
        self.animeItem = animeItem
        super.init()
        requestWatchingEntity()
    }
}

// MARK: - Internal methods

extension EpisodesModel {
    func requestWatchingEntity() {
        guard let userLogin = userDefaults.userLogin else { return }
        do {
            let userEntity = try UserEntity.find(userLogin: userLogin, context: coreDataService.viewContext)
            watchingEntity = try WatchingEntity.find(forUser: userEntity, animeId: animeItem.id, context: coreDataService.viewContext)
        } catch {
            let coreDataLogger = Logger(subsystem: .episode, category: .coreData)
            coreDataLogger.error("\(Logger.logInfo(error: error))")
        }
    }
    
    func getPlaylists() -> [Playlist] {
        return animeItem.playlist
    }
    
    func getAnimeItem() -> AnimeItem {
        return animeItem
    }
    
    func getEpisodesDescription() -> String? {
        return animeItem.episodes?.string
    }
    
    func getWatchingInfo(forEpisode episode: Float?) -> (duration: Double, playbackTime: Double)? {
        guard let episode else { return nil }
        guard let episodesEntities = watchingEntity?.episodes as? Set<EpisodesEntity>, episodesEntities.isEmpty == false else { return nil }
        
        guard let result = episodesEntities.filter({ $0.numberOfEpisode == episode }).first else { return nil }
        return (result.duration, result.playbackPosition)
    }
}
