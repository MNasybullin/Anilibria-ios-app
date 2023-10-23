//
//  HomeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

class HomeModel {
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

extension HomeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // swiftlint: disable operator_whitespace
    static func ==(lhs: HomeModel, rhs: HomeModel) -> Bool {
        return lhs.id == rhs.id
    }
    // swiftlint: enable operator_whitespace
}

// MARK: - For SkeletonView

extension HomeModel {
    static func getSkeletonInitialData() -> [HomeModel] {
        var data: [HomeModel] = []
        for number in 0..<5 {
            let model = HomeModel(id: number, name: "", imageUrlString: "")
            data.append(model)
        }
        return data
    }
}
