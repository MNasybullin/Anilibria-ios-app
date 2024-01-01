//
//  SeriesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import Foundation

final class SeriesModel: ImageModel {
    private var animeItem: AnimeItem
    
    // MARK: CoreData Properties
    private let coreDataService = CoreDataService.shared
    private var watchingEntity: WatchingEntity?
    
    init(animeItem: AnimeItem) {
        self.animeItem = animeItem
        super.init()
        setupSerieEntities()
    }
}

// MARK: - Private methods

private extension SeriesModel {
    func setupSerieEntities() {
        guard let userId = UserDefaults.standard.userId else { return }
        do {
            let userEntity = try UserEntity.find(userId: userId, context: coreDataService.viewContext)
            watchingEntity = try WatchingEntity.find(forUser: userEntity, animeId: animeItem.id, context: coreDataService.viewContext)
        } catch {
            print(error)
        }
    }
}

// MARK: - Internal methods

extension SeriesModel {
    func getPlaylists() -> [Playlist] {
        return animeItem.playlist
    }
    
    func getAnimeItem() -> AnimeItem {
        return animeItem
    }
    
    func getSeriesDescription() -> String? {
        return animeItem.series?.string
    }
    
    func getWatchingInfo(forSerie serie: Double) -> (duration: Double, playbackTime: Double)? {
        guard let serieEntities = watchingEntity?.series as? Set<SeriesEntity>, serieEntities.isEmpty == false else { return nil }
        
        guard let result = serieEntities.filter({ $0.numberOfSerie == serie }).first else { return nil }
        return (result.duration, result.playbackPosition)
    }
}
