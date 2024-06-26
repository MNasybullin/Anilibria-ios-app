//
//  ProfileModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.02.2024.
//

import Foundation

final class ProfileModel {
    
    private let publicApiService = PublicApiService()
    private let remoteConfig = AppRemoteConfig.shared
}

// MARK: - Internal methods

extension ProfileModel {
    func getUrl(forAnilibriaItem item: ProfileContentController.AnilibriaItem) -> URL? {
        switch item {
            case .discord: return URL(string: NetworkConstants.anilibriaDiscord)
            case .site: return URL(string: remoteConfig.string(forKey: .mirrorAnilibriaURL))
            case .team: return nil
            case .telegram: return URL(string: NetworkConstants.anilibriaTelegram)
            case .vk: return URL(string: NetworkConstants.anilibriaVk)
            case .youtube: return URL(string: NetworkConstants.anilibriaYouTube)
        }
    }
    
    func getTeam() async throws -> TeamAPIModel {
        try await publicApiService.team()
    }
    
    func getAnilbriaDonateURL() -> URL? {
        URL(string: remoteConfig.string(forKey: .mirrorAnilibriaURL) + NetworkConstants.donateURLPath)
    }
    
    func getDeveloperDonateURL() -> URL? {
        URL(string: remoteConfig.string(forKey: .myDonateURL))
    }
}
