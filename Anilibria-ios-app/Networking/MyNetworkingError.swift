//
//  MyNetworkingError.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.07.2022.
//

import Foundation

enum MyNetworkingError: Error {
    case unknown(code: Int = 0, message: String = Strings.NetworkingError.unknown)
    case invalidServerResponse(code: Int = 1, message: String = Strings.NetworkingError.invalidServerResponse)
    
    /// Пользователь не авторизован. Code: 2
    case userIsNotAuthorized(code: Int = 401, message: String = Strings.NetworkingError.userIsNotAuthorized)
    
    /// Неверный запрос. Code: 400
    case invalidURLComponents(code: Int = 400, message: String = Strings.NetworkingError.invalidURLComponents)
    
    /// Возникает в случае непредвиденной внутренней ошибки сервера. Code: 500
    case internalServerError(code: Int = 500, message: String = Strings.NetworkingError.internalServerError)
    
    /// Возникает в случае если передать неизвестный параметр в запросе. Code: 412
    case unknownParameters(code: Int = 412, message: String = Strings.NetworkingError.unknownParameters)
    
    /// Возникает в случае если запрошен тайтл которого нет в базе. Code: 404
    case notFound(code: Int = 404, message: String = Strings.NetworkingError.notFound)
}

struct MyError: Error, Codable {
    let code: Int
    let message: String
}
