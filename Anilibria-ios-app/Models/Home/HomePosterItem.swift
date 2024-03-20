//
//  HomePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

struct HomePosterItem: PosterItem {
    let id: Int
    let name: String
    let imageUrlString: String
    var image: UIImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageUrlString)
    }
    
    static func == (lhs: HomePosterItem, rhs: HomePosterItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.imageUrlString == rhs.imageUrlString
    }
}

extension HomePosterItem {
    init(fromTitleAPIModel model: TitleAPIModel) {
        self.init(
            id: model.id,
            name: model.names.ru,
            imageUrlString: AppRemoteConfig.shared.string(forKey: .mirrorBaseImagesURL) + model.posters.original.url
        )
    }
    
    init(fromYouTubeAPIModel model: YouTubeAPIModel) {
        var imageUrlString = ""
        if let previewUrl = model.preview.src {
            imageUrlString = AppRemoteConfig.shared.string(forKey: .mirrorBaseImagesURL) + previewUrl
        }
        self.init(id: model.id, name: model.title, imageUrlString: imageUrlString)
    }
}
