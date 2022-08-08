//
//  FavoriteModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation

/// Возвращается в запросах:
/// addFavorite, delFavorite
struct FavoriteModel: Codable {
    let error: MyError?
    let success: Bool?
}

struct MyError: Error, Codable {
    let code: Int
    let message: String
}
