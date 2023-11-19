//
//  RandomAnimeItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

struct RandomAnimeItem {
    let ruName: String
    let engName: String?
    let description: String?
    var image: UIImage?
}

extension RandomAnimeItem {
    init(from titleAPIModel: TitleAPIModel, image: UIImage) {
        self.init(ruName: titleAPIModel.names.ru,
                  engName: titleAPIModel.names.en,
                  description: titleAPIModel.description,
                  image: image)
    }
}
