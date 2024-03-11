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
    case invalidURL
    case failedToDownSampling
}

extension MyImageError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .failedToInitialize:
                return Strings.ImageError.failedToInitialize
            case .invalidURL:
                return Strings.ImageError.invalidURL
            case .failedToDownSampling:
                return Strings.ImageError.failedToDownSampling
        }
    }
}
