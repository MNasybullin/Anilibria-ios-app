//
//  HomeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

class HomeModel {
    var identifier: String = UUID().uuidString
    var name: String
    var imageUrlString: String
    var image: UIImage?
    
    init(name: String, imageUrlString: String, image: UIImage? = nil) {
        self.name = name
        self.imageUrlString = imageUrlString
        self.image = image
    }
    
    convenience init(from model: TitleAPIModel) {
        self.init(name: model.names.ru,
                  imageUrlString: model.posters.original.url,
                  image: nil)
    }
}

extension HomeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // swiftlint: disable operator_whitespace
    static func ==(lhs: HomeModel, rhs: HomeModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    // swiftlint: enable operator_whitespace
}
