//
//  AnimeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit
import OSLog

protocol AnimeModelOutput: AnyObject {
    func update(image: UIImage)
}

final class AnimeModel {
    weak var delegate: AnimeModelOutput?
    
    private let favoriteModel = FavoritesModel.shared
    private let userDefaults = UserDefaults.standard
    private let remoteConfig = AppRemoteConfig.shared
    
    private let rawData: TitleAPIModel
    private var animeItem: AnimeItem
    
    private let coreDataService = CoreDataService.shared
    private var lastWatchingEpisodeNumber: Float?
    
    init(rawData: TitleAPIModel, image: UIImage?) {
        self.rawData = rawData
        self.animeItem = AnimeItem(fromTitleApiModel: rawData, image: image)
        
        setupCurrentEpisodeEntity()
    }
}

// MARK: - Private methods

private extension AnimeModel {
    func requestImage() {
        Task(priority: .userInitiated) {
            do {
                let url = remoteConfig.string(forKey: .mirrorBaseImagesURL) + rawData.posters.original.url
                let imageData = try await ImageLoaderService.shared.getImageData(fromURLString: url)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                self.animeItem.image = image
                delegate?.update(image: image)
            } catch {
                let logger = Logger(subsystem: .anime, category: .image)
                logger.error("\(Logger.logInfo(error: error))")
            }
        }
    }
    
    func setupCurrentEpisodeEntity() {
        guard let userLogin = userDefaults.userLogin else { return }
        do {
            let userEntity = try UserEntity.find(userLogin: userLogin, context: coreDataService.viewContext)
            let watchingEntity = try WatchingEntity.find(forUser: userEntity, animeId: animeItem.id, context: coreDataService.viewContext)
            let episodes = watchingEntity.episodes as? Set<EpisodesEntity>
            guard let episode = episodes?.sorted(by: { $0.watchingDate > $1.watchingDate }).first else {
                return
            }
            lastWatchingEpisodeNumber = episode.numberOfEpisode
        } catch {
            let coreDataLogger = Logger(subsystem: .anime, category: .coreData)
            coreDataLogger.error("\(Logger.logInfo(error: error))")
        }
    }
}

// MARK: - Internal methods

extension AnimeModel {
    func getAnimeItem() -> AnimeItem {
        if animeItem.image == nil {
            requestImage()
        }
        return animeItem
    }
    
    func getSharedText() -> String {
        let item = getAnimeItem()
        let releaseUrl = "/release/" + item.code + ".html"
        let textToShare = """
            \(item.ruName)
            \(remoteConfig.string(forKey: .anilibriaURL) + releaseUrl)
            Зеркало: \(remoteConfig.string(forKey: .mirrorAnilibriaURL) + releaseUrl)
            """
        return textToShare
    }
    
    func isFavorite() async throws -> Bool {
        return try await favoriteModel.isFavorite(title: rawData)
    }
    
    func addFavorite() async throws {
        try await favoriteModel.addFavorite(title: rawData)
    }
    
    func delFavorite() async throws {
        try await favoriteModel.delFavorite(title: rawData)
    }
    
    func getFranchises() -> [FranchisesAPIModel] {
        rawData.franchises
    }
    
    func isAuthorized() -> Bool {
        userDefaults.isUserAuthorized
    }
    
    func getContinueWatchingEpisodeNumber() -> Float? {
        lastWatchingEpisodeNumber
    }
    
    func getContinueWatchingCurrentPlaylist() -> Int? {
        animeItem.playlist.firstIndex(where: { $0.episode == lastWatchingEpisodeNumber })
    }
}
