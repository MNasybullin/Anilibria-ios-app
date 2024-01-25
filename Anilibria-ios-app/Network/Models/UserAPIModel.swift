//
//  UserAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation

struct UserAPIModel: Decodable {
    let login: String
    let nickname: String?
    let email: String
    let avatar: String?
    let avatarOriginal: String
    let vkId: String?
    let patreonId: String?
}
