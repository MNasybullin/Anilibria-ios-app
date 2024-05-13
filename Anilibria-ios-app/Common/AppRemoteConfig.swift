//
//  AppRemoteConfig.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.03.2024.
//

import FirebaseRemoteConfig
import OSLog

final class AppRemoteConfig {
    
    enum StringKeys: String {
        case mirrorAnilibriaURL
        case mirrorBaseImagesURL
        
        case apiAnilibriaURL
        case anilibriaURL
        case baseImagesURL
        
        case appVersion
        case appVersionNews
        
        case myDonateURL
    }
    
    enum NumberKeys: String {
        case vkCommentsAnilibriaAppID
    }
    
    static let shared = AppRemoteConfig()
    private let appVersionManager = AppVersionManager()
    
    private let logger = Logger(subsystem: .remoteConfig, category: .empty)
    
    private init() {
        loadDefaultValues()
        setupConfigSettings()
        fetchCloudValues()
    }
}

// MARK: - Private methods

private extension AppRemoteConfig {
    func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            StringKeys.mirrorAnilibriaURL.rawValue: "https://ios.anilib.moe",
            StringKeys.mirrorBaseImagesURL.rawValue: "https://static.anilib.moe",
            
            StringKeys.apiAnilibriaURL.rawValue: "https://api.anilibria.tv",
            StringKeys.anilibriaURL.rawValue: "https://www.anilibria.tv",
            StringKeys.baseImagesURL.rawValue: "https://static.anilibria.tv",
            
            StringKeys.appVersion.rawValue: appVersionManager.currentVersion ?? "",
            StringKeys.appVersionNews.rawValue: "",
            
            StringKeys.myDonateURL.rawValue: "https://www.tinkoff.ru/rm/nasybullin.mansur1/kl1CO83559",
            
            NumberKeys.vkCommentsAnilibriaAppID.rawValue: 5315207
        ]
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func setupConfigSettings() {
        let settings = RemoteConfigSettings()
#if DEBUG
        settings.minimumFetchInterval = 0
#else
        settings.minimumFetchInterval = 1 * 60 * 60 // 1 Hour
#endif
        RemoteConfig.remoteConfig().configSettings = settings
    }
    
    func fetchCloudValues() {
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
    func string(forKey key: StringKeys) -> String {
        RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func number(forKey key: NumberKeys) -> Int {
        Int(truncating: RemoteConfig.remoteConfig()[key.rawValue].numberValue)
    }
}
