//
//  ProfileModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation

struct ProfileModel: Codable {
    let status: Bool
    let data: PUser?
    let error: MyError?
}

struct PUser: Codable {
    let id: Int
    let login: String
    let avatar: String
}
