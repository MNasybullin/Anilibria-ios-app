//
//  AppUpdateModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.04.2024.
//

import Foundation

final class AppUpdateModel {
    private let appRemoteConfig = AppRemoteConfig.shared
    private let appVersionManager = AppVersionManager()
    
    func isNeedUpdateApp() -> Bool {
        let remoteAppVersion = appRemoteConfig.string(forKey: .appVersion)
        if remoteAppVersion.isEmpty {
            return false
        }
        return appVersionManager.currentVersionIsLessThan(version: remoteAppVersion)
    }
    
    func getAppVersion() -> String {
        let currentVersion = appVersionManager.currentVersion
        let remoteAppVersion = appRemoteConfig.string(forKey: .appVersion)
        return "\(currentVersion ?? "") -> \(remoteAppVersion)"
    }
    
    func getNews() -> String {
        appRemoteConfig.string(forKey: .appVersionNews)
    }
}
