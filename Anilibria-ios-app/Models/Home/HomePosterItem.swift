//
//  HomePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

struct HomePosterItem {
    let name: String
    let imageUrlString: String
    var image: UIImage?
}

extension HomePosterItem {
    init(fromTitleAPIModel model: TitleAPIModel) {
        self.init(
            name: model.names.ru,
            imageUrlString: NetworkConstants.mirrorBaseImagesURL + model.posters.original.url
        )
    }
    
    init(fromYouTubeAPIModel model: YouTubeAPIModel) {
        self.init(name: model.title, imageUrlString: model.image)
    }
}
