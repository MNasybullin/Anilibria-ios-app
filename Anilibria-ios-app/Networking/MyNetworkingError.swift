//
//  MyNetworkingError.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.07.2022.
//

import Foundation

enum MyNetworkingError: Error {
    /// Неизвестная ошибка. Code = 0.
    case unknown
    
    /// Неверный ответ от сервера. Code = 1.
    case invalidServerResponse
    
    /// Пользователь не авторизован. Code = 401.
    case userIsNotAuthorized
    
    /// Неверный запрос. Code = 400.
    case invalidURLComponents
    
    /// Возникает в случае непредвиденной внутренней ошибки сервера. Code = 500.
    case internalServerError
    
    /// Возникает в случае, если передать неизвестный параметр в запросе. Code = 412.
    case unknownParameters
    
    /// Возникает в случае, если запрошен тайтл которого нет в базе. Code = 404.
    case notFound
    
    /// Возникает в случае, если соединение с интернетом прервано. Code = -1009.
    case noInternetConnection
    
    /// Произошла ошибка SSL. Безопасное подключение к серверу невозможно. Code = -1200.
    case useVPN
}

extension MyNetworkingError: CustomStringConvertible {
    var description: String {
        switch self {
            case .unknown:
                return Strings.NetworkingError.unknown
            case .invalidServerResponse:
                return Strings.NetworkingError.invalidServerResponse
            case .userIsNotAuthorized:
                return Strings.NetworkingError.userIsNotAuthorized
            case .invalidURLComponents:
                return Strings.NetworkingError.invalidURLComponents
            case .internalServerError:
                return Strings.NetworkingError.internalServerError
            case .unknownParameters:
                return Strings.NetworkingError.unknownParameters
            case .notFound:
                return Strings.NetworkingError.notFound
            case .noInternetConnection:
                return Strings.NetworkingError.noInternetConnection
            case .useVPN:
                return Strings.NetworkingError.useVPN
        }
    }
}
