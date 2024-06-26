//
//  HomeWatchingModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.02.2024.
//

import UIKit

final class HomeWatchingModel {
    private let coreDataService = CoreDataService.shared
    private let publicApiService = PublicApiService()
    
    private let userDefaults = UserDefaults.standard
    private let blankImage = Asset.Assets.blankImage.image
}

// MARK: - Private methods

private extension HomeWatchingModel {
    
}

// MARK: - Internal methods

extension HomeWatchingModel {
    func requestData() throws -> [HomeWatchingItem] {
        var result = [HomeWatchingItem]()
        
        guard let userLogin = userDefaults.userLogin else {
            return result
        }
        
        let userEntity = try UserEntity.find(userLogin: userLogin, context: coreDataService.viewContext)
        let watching = userEntity.watching?.allObjects as? [WatchingEntity]
        watching?.forEach {
            guard $0.isHidden == false else {
                return
            }
            let episodes = $0.episodes as? Set<EpisodesEntity>
            guard let episode = episodes?.sorted(by: { $0.watchingDate > $1.watchingDate }).first else {
                return
            }
            
            let item = HomeWatchingItem(
                id: Int($0.animeId),
                title: $0.animeName,
                subtitle: "\(Int(episode.numberOfEpisode)) серия",
                watchingDate: episode.watchingDate,
                duration: episode.duration,
                numberOfEpisode: episode.numberOfEpisode,
                playbackPosition: episode.playbackPosition,
                image: $0.animeImage ?? blankImage)
            result.append(item)
        }
        
        result.sort { $0.watchingDate > $1.watchingDate }
        return result
    }
    
    func hideWatchingEntity(id: Int) throws {
        guard let userLogin = userDefaults.userLogin else {
            throw MyInternalError.userIsNotFoundInUserDefaults
        }
        
        let userEntity = try UserEntity.find(userLogin: userLogin, context: coreDataService.viewContext)
        let watching = userEntity.watching?.allObjects as? [WatchingEntity]
        guard let entity = watching?.first(where: { $0.animeId == id }) else {
            throw MyInternalError.failedToFetchData
        }
        entity.isHidden = true
    }
    
    func requestAnimeData(forAnimeId animeId: Int) async throws -> TitleAPIModel {
        let data = try await publicApiService.title(id: animeId.description)
        return data
    }
}
