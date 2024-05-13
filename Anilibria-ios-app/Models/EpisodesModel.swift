//
//  EpisodesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import Foundation
import OSLog

final class EpisodesModel: ImageModel {
    enum WatchingInfo {
        case fullWatched
        case notWatched
    }
    
    private var animeItem: AnimeItem
    
    // MARK: CoreData Properties
    private let coreDataService = CoreDataService.shared
    private let userDefaults = UserDefaults.standard
    
    private var userEntity: UserEntity?
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
            userEntity = try UserEntity.find(userLogin: userLogin, context: coreDataService.viewContext)
            watchingEntity = try WatchingEntity.find(forUser: userEntity!, animeId: animeItem.id, context: coreDataService.viewContext)
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
    
    func setWatchingInfo(forEpisode episode: Float?, info: WatchingInfo) {
        guard let userEntity else {
            return
        }
        if watchingEntity == nil {
            watchingEntity = WatchingEntity.create(forUser: userEntity, animeItem: animeItem, context: coreDataService.viewContext)
        }
        let episodes = watchingEntity?.episodes as? Set<EpisodesEntity>
        let episodeEntity = episodes?.filter({ $0.numberOfEpisode == episode }).first
        
        switch info {
            case .fullWatched:
                if let episodeEntity {
                    episodeEntity.duration = 0
                    episodeEntity.playbackPosition = 0
                    episodeEntity.watchingDate = Date()
                } else {
                    _ = EpisodesEntity.create(forWatching: watchingEntity!,
                                         context: coreDataService.viewContext,
                                         duration: 0,
                                         playbackPosition: 0,
                                         numberOfEpisode: episode,
                                         image: nil)
                }
            case .notWatched:
                if let episodeEntity {
                    watchingEntity?.removeFromEpisodes(episodeEntity)
                }
        }
    }
    
    func isUserAuthorized() -> Bool {
        userDefaults.isUserAuthorized && userDefaults.userLogin != nil
    }
}
