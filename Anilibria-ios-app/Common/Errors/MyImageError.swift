//
//  MyImageError.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 09.08.2022.
//

import Foundation

enum MyImageError: Error {
    /// Ошибка инициализации изображения из data
    case failedToInitialize
}

extension MyImageError: CustomStringConvertible {
    var description: String {
        switch self {
            case .failedToInitialize:
                return Strings.ImageError.failedToInitialize
        }
    }
}
