//
//  HomePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

struct HomePosterItem: Hashable {
    let name: String
    let imageUrlString: String
    var image: UIImage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(imageUrlString)
    }
    
    static func == (lhs: HomePosterItem, rhs: HomePosterItem) -> Bool {
        lhs.name == rhs.name && lhs.imageUrlString == rhs.imageUrlString
    }
}

extension HomePosterItem {
    init(fromTitleAPIModel model: TitleAPIModel) {
        self.init(
            name: model.names.ru,
            imageUrlString: NetworkConstants.mirrorBaseImagesURL + model.posters.original.url
        )
    }
    
    init(fromYouTubeAPIModel model: YouTubeAPIModel) {
        self.init(name: model.title, imageUrlString: NetworkConstants.mirrorBaseImagesURL + model.preview.src)
    }
}
