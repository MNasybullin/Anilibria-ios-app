//
//  AnimePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

struct AnimePosterItem {
    let name: String
    let imageUrlString: String
    var image: UIImage?
}

extension AnimePosterItem {
    init(titleAPIModel model: TitleAPIModel) {
        self.init(name: model.names.ru,
                  imageUrlString: model.posters.original.url,
                  image: nil)
    }
}
