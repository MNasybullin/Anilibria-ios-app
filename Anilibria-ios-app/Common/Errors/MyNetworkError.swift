//
//  MyNetworkError.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.07.2022.
//

import Foundation

enum MyNetworkError: Error {
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
    case internetConnectionInterrupted
    
    /// Произошла ошибка SSL. Безопасное подключение к серверу невозможно. Code = -1200.
    case useVPN
}

extension MyNetworkError: CustomStringConvertible {
    var description: String {
        switch self {
            case .unknown:
                return Strings.NetworkError.unknown
            case .invalidServerResponse:
                return Strings.NetworkError.invalidServerResponse
            case .userIsNotAuthorized:
                return Strings.NetworkError.userIsNotAuthorized
            case .invalidURLComponents:
                return Strings.NetworkError.invalidURLComponents
            case .internalServerError:
                return Strings.NetworkError.internalServerError
            case .unknownParameters:
                return Strings.NetworkError.unknownParameters
            case .notFound:
                return Strings.NetworkError.notFound
            case .internetConnectionInterrupted:
                return Strings.NetworkError.internetConnectionInterrupted
            case .useVPN:
                return Strings.NetworkError.useVPN
        }
    }
}
