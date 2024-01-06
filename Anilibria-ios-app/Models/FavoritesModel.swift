//
//  FavoritesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.01.2024.
//

import Foundation

final class FavoritesModel: ImageModel {
    static let shared = FavoritesModel()
    
    private let authorizationService = AuthorizationService()
    private let expiredDateManager = ExpiredDateManager(expireTimeInMinutes: 1)
    
    private var titles: [TitleAPIModel]?
    
    private override init() { }
    
}

// MARK: - Internal methods
extension FavoritesModel {
    func addFavorite(title: TitleAPIModel) async throws {
        try await authorizationService.addFavorite(from: title.id)
        titles?.append(title)
    }
    
    func delFavorite(title: TitleAPIModel) async throws {
        try await authorizationService.delFavorite(from: title.id)
        titles?.removeAll { $0.id == title.id }
    }
    
    func getFavorites(withForceUpdate forceUpdate: Bool = false) async throws -> [TitleAPIModel] {
        if let titles, forceUpdate == false, expiredDateManager.isExpired() == false {
            return titles
        }
        let favorites = try await authorizationService.getFavorites()
        titles = favorites
        expiredDateManager.start()
        return favorites
    }
    
    func isFavorite(title: TitleAPIModel) async throws -> Bool {
        let favorites = try await getFavorites()
        return favorites.contains { $0.id == title.id }
    }
    
    func getTitleModel(fromName name: String) -> TitleAPIModel? {
        return titles?.first { $0.names.ru == name }
    }
}
