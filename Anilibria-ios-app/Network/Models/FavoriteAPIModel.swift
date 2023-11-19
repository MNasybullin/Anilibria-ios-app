//
//  FavoriteAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation

/// Возвращается в запросах:
/// addFavorite, delFavorite
struct FavoriteAPIModel: Decodable {
    let error: APIError?
    let success: Bool?
}

struct APIError: Error, Decodable {
    let code: Int
    let message: String
}
