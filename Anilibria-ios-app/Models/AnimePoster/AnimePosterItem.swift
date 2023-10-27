//
//  AnimePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

final class AnimePosterItem {
    var name: String
    var imageUrlString: String
    var image: UIImage?
        
    init(name: String, imageUrlString: String, image: UIImage? = nil) {
        self.name = name
        self.imageUrlString = imageUrlString
        self.image = image
    }
    
    convenience init(titleAPIModel model: TitleAPIModel) {
        self.init(name: model.names.ru,
                  imageUrlString: model.posters.original.url,
                  image: nil)
    }
}

// MARK: - For SkeletonView

extension AnimePosterItem {
    static func getSkeletonInitialData() -> AnimePosterItem {
        return AnimePosterItem(name: "", imageUrlString: "")
    }
}
