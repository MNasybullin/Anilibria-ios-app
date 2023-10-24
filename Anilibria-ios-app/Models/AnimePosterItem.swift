//
//  AnimePosterItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

class AnimePosterItem {
    var id: Int
    var name: String
    var imageUrlString: String
    var image: UIImage?
        
    init(id: Int, name: String, imageUrlString: String, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.imageUrlString = imageUrlString
        self.image = image
    }
    
    convenience init(from model: TitleAPIModel) {
        self.init(id: model.id,
                  name: model.names.ru,
                  imageUrlString: model.posters.original.url,
                  image: nil)
    }
}

// MARK: - Hashable

extension AnimePosterItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // swiftlint: disable operator_whitespace
    static func ==(lhs: AnimePosterItem, rhs: AnimePosterItem) -> Bool {
        return lhs.id == rhs.id
    }
    // swiftlint: enable operator_whitespace
}

// MARK: - For SkeletonView

extension AnimePosterItem {
    static func getSkeletonInitialData() -> [AnimePosterItem] {
        var data: [AnimePosterItem] = []
        for number in 0..<5 {
            let model = AnimePosterItem(id: number, name: "", imageUrlString: "")
            data.append(model)
        }
        return data
    }
}
