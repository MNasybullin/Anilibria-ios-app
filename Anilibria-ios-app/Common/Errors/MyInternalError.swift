//
//  MyInternalError.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.12.2022.
//

import Foundation

enum MyInternalError: Error {
    /// Не удалось получить URL из данных
    case failedToFetchURLFromData
    /// Не удалось извлечь данные
    case failedToFetchData
    /// Пользователь не авторизован в UserDefaults
    case userIsNotFoundInUserDefaults
}

extension MyInternalError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .failedToFetchURLFromData:
                return Strings.InternalError.failedToFetchURLFromData
            case .failedToFetchData:
                return Strings.InternalError.failedToFetchData
            case .userIsNotFoundInUserDefaults:
                return Strings.InternalError.userIsNotFoundInUserDefaults
        }
    }
}
