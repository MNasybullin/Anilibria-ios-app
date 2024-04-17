//
//  AppRemoteConfig.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.03.2024.
//

import FirebaseRemoteConfig
import OSLog

final class AppRemoteConfig {
    
    enum Keys: String {
        case mirrorAnilibriaURL
        case mirrorBaseImagesURL
        
        case apiAnilibriaURL
        case anilibriaURL
        case baseImagesURL
        
        case appVersion
        case appVersionNews
    }
    
    static let shared = AppRemoteConfig()
    private let appVersionManager = AppVersionManager()
    
    private let logger = Logger(subsystem: .remoteConfig, category: .empty)
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
}

// MARK: - Private methods

private extension AppRemoteConfig {
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            Keys.mirrorAnilibriaURL.rawValue: "https://anilibria-ios-app.anilib.moe",
            Keys.mirrorBaseImagesURL.rawValue: "https://static.anilib.moe",
            
            Keys.apiAnilibriaURL.rawValue: "https://api.anilibria.tv",
            Keys.anilibriaURL.rawValue: "https://www.anilibria.tv",
            Keys.baseImagesURL.rawValue: "https://static.anilibria.tv",
            
            Keys.appVersion.rawValue: appVersionManager.currentVersion ?? "",
            Keys.appVersionNews.rawValue: ""
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func activateDebugMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func activateReleseMode() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 1 * 60 * 60 // 1 Hour
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func fetchCloudValues() {
#if DEBUG
        activateDebugMode()
#else
        activateReleseMode()
#endif
        
        RemoteConfig.remoteConfig().fetch { [weak self] _, error in
            if let error = error {
                self?.logger.error("\(Logger.logInfo(error: error)) AppRemoteConfig error fetched values from the cloud")
                return
            }
            RemoteConfig.remoteConfig().activate { [weak self] _, _ in
                self?.logger.debug("AppRemoteConfig is activate, values ​​received from the cloud!")
                
                if AppUpdateModel().isNeedUpdateApp() {
                    MainNavigator.shared.rootViewController.configureTabBarBadge(item: .profile, badgeValue: "")
                }
            }
        }
    }
}

// MARK: - Internal methods

extension AppRemoteConfig {
    func string(forKey key: Keys) -> String {
        RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
}
