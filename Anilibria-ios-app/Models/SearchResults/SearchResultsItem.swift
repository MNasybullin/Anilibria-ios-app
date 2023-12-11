//
//  SearchResultsItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.11.2023.
//

import UIKit

struct SearchResultsItem {
    let ruName: String
    let engName: String?
    let description: String?
    let imageUrlString: String
    var image: UIImage?
}

extension SearchResultsItem {
    init(from titleAPIModel: TitleAPIModel, image: UIImage?) {
        self.init(ruName: titleAPIModel.names.ru,
                  engName: titleAPIModel.names.en,
                  description: titleAPIModel.description, 
                  imageUrlString: NetworkConstants.mirrorBaseImagesURL + titleAPIModel.posters.original.url,
                  image: image)
    }
}
