//
//  LoginModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.08.2022.
//

import Foundation

struct Login: Codable {
    enum CodingKeys: String, CodingKey {
        case error = "err"
        case message = "mes"
        case key
        case sessionId
    }
    
    let error: String
    let message: String
    let key: String
    let sessionId: String?
}

enum KeyLogin: String, Codable {
    case authorized
    case success
    case invalidUser
    case empty
    case wrongPasswd
}
