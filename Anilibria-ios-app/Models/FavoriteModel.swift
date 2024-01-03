//
//  FavoriteModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.01.2024.
//

import Foundation

final class FavoriteModel {
    static let shared: FavoriteModel = FavoriteModel()
    private let authorizationService = AuthorizationService()
    
    private var titles: [TitleAPIModel]?
    private lazy var dataExpiredDate: Date = getExpiredDate()
    
    private init() { }
    
}

// MARK: - Private methods
extension FavoriteModel {
    func getExpiredDate() -> Date {
        var date = Date()
        let minute: Double = 60
        date.addTimeInterval(1 * minute)
        return date
    }
    
    func dataIsExpired() -> Bool {
        return Date().compare(dataExpiredDate) == .orderedDescending
    }
}

// MARK: - Internal methods
extension FavoriteModel {
    func addFavorite(title: TitleAPIModel) async throws {
        try await authorizationService.addFavorite(from: title.id)
        titles?.append(title)
    }
    
    func delFavorite(title: TitleAPIModel) async throws {
        try await authorizationService.delFavorite(from: title.id)
        titles?.removeAll { $0.id == title.id }
    }
    
    func getFavorites(withForceUpdate forceUpdate: Bool = false) async throws -> [TitleAPIModel] {
        if let titles, forceUpdate == false, dataIsExpired() == false {
            return titles
        }
        let favorites = try await authorizationService.getFavorites()
        titles = favorites
        dataExpiredDate = getExpiredDate()
        return favorites
    }
    
    func isFavorite(title: TitleAPIModel) async throws -> Bool {
        let favorites = try await getFavorites()
        return favorites.contains { $0.id == title.id }
    }
}
