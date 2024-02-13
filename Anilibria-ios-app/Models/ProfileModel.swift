//
//  ProfileModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.02.2024.
//

import Foundation

final class ProfileModel {
    
    private let publicApiService = PublicApiService()
    
    init() {
    }
}

// MARK: - Internal methods

extension ProfileModel {
    func getUrl(forAnilibriaItem item: ProfileContentController.AnilibriaItem) -> URL? {
        switch item {
            case .discord: return URL(string: NetworkConstants.anilibriaDiscord)
            case .site: return URL(string: NetworkConstants.anilibriaURL)
            case .team: return nil
            case .telegram: return URL(string: NetworkConstants.anilibriaTelegram)
            case .vk: return URL(string: NetworkConstants.anilibriaVk)
            case .youtube: return URL(string: NetworkConstants.anilibriaYouTube)
        }
    }
    
    func getTeam() async throws -> TeamAPIModel {
        try await publicApiService.team()
    }
}
