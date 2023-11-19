//
//  AnimeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

protocol AnimeModelOutput: AnyObject {
    func update(image: UIImage)
}

final class AnimeModel {
    private let rawData: TitleAPIModel
    private var image: UIImage?
    
    weak var delegate: AnimeModelOutput?
    
    init(rawData: TitleAPIModel, image: UIImage?) {
        self.rawData = rawData
        self.image = image
    }
}

// MARK: - Private methods

private extension AnimeModel {
    func requestImage() {
        Task {
            do {
                let url = rawData.posters.original.url
                let imageData = try await ImageLoaderService.shared.getImageData(from: url)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                self.image = image
                delegate?.update(image: image)
            } catch {
                print(#function, error)
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
}
