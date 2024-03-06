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
    private let rawData: TitleAPIModel
    private var image: UIImage?
    
    weak var delegate: AnimeModelOutput?
    private let favoriteModel = FavoritesModel.shared
    
    init(rawData: TitleAPIModel, image: UIImage?) {
        self.rawData = rawData
        self.image = image
    }
}

// MARK: - Private methods

private extension AnimeModel {
    func requestImage() {
        Task(priority: .userInitiated) {
            do {
                let url = NetworkConstants.mirrorBaseImagesURL + rawData.posters.original.url
                let imageData = try await ImageLoaderService.shared.getImageData(fromURLString: url)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                self.image = image
                delegate?.update(image: image)
            } catch {
                let logger = Logger(subsystem: .anime, category: .image)
                logger.error("\(Logger.logInfo()) \(error)")
            }
        }
    }
}

// MARK: - Internal methods

extension AnimeModel {
    func getAnimeItem() -> AnimeItem {
        if image == nil {
            requestImage()
        }
        return AnimeItem(fromTitleApiModel: rawData, image: image)
    }
    
    func getSharedText() -> String {
        let item = getAnimeItem()
        let releaseUrl = "/release/" + item.code + ".html"
        let textToShare = """
            \(item.ruName)
            \(NetworkConstants.anilibriaURL + releaseUrl)
            Зеркало: \(NetworkConstants.mirrorAnilibriaURL + releaseUrl)
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
}
