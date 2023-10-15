//
//  ProfileAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation

struct ProfileAPIModel: Decodable {
    let status: Bool
    let data: PUser?
    let error: APIError?
}

struct PUser: Decodable {
    let id: Int
    let login: String
    let avatar: String
}
