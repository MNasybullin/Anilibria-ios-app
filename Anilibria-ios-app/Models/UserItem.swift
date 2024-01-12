//
//  UserItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.11.2023.
//

import UIKit

struct UserItem {
    let id: Int
    let name: String
    let image: UIImage?
    let imageUrl: String
}

extension UserItem {
    init(userEntity model: UserEntity) {
        self.init(
            id: Int(model.id),
            name: model.name,
            image: model.image,
            imageUrl: model.imageUrl
        )
    }
}
