//
//  LoginAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.08.2022.
//

import Foundation

/// Возвращается в запросах:
/// login
struct LoginAPIModel: Decodable {
    // error
    let err: String
    // message
    let mes: String
    let key: String
    let sessionId: String?
}

/// Варианты значений key в Login возвращаемые сервером
enum KeyLoginAPI: String, Decodable {
    case authorized
    case success
    case invalidUser
    case empty
    case wrongPasswd
}
