//
//  UserItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.11.2023.
//

import UIKit

struct UserItem {
    let login: String
    let nickname: String?
    let email: String
    let vkId: String?
    let patreonId: String?
    var image: UIImage?
    let imageUrl: String
}

extension UserItem {
    init(userEntity model: UserEntity) {
        self.init(login: model.login,
                  nickname: model.nickname,
                  email: model.email,
                  vkId: model.vkId,
                  patreonId: model.patreonId,
                  image: model.image,
                  imageUrl: AppRemoteConfig.shared.string(forKey: .mirrorBaseImagesURL) + model.imageUrl
        )
    }
    
    init(userApiModel model: UserAPIModel) {
        var imageUrl: String
        if let avatarOriginal = model.avatarOriginal {
            imageUrl = AppRemoteConfig.shared.string(forKey: .mirrorBaseImagesURL) + avatarOriginal
        } else {
            imageUrl = AppRemoteConfig.shared.string(forKey: .mirrorBaseImagesURL) + NetworkConstants.noAvatarSuffix
        }
        self.init(login: model.login,
                  nickname: model.nickname,
                  email: model.email,
                  vkId: model.vkId,
                  patreonId: model.patreonId,
                  imageUrl: imageUrl
        )
    }
}
