//
//  MyError.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.12.2022.
//

import Foundation

enum MyInternalError: Error {
    /// Не удалось извлечь данные
    case failedToFetchData
}

extension MyInternalError: CustomStringConvertible {
    var description: String {
        switch self {
            case .failedToFetchData:
                return Strings.InternalError.failedToFetchData
        }
    }
}
