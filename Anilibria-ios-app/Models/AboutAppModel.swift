//
//  AboutAppModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.02.2024.
//

import Foundation

final class AboutAppModel {
    private let appVersionManager = AppVersionManager()
    
    func getAppVersion() -> String {
        return appVersionManager.currentVersion ?? ""
    }
    
    func getGithubURL() -> URL {
        URL(string: NetworkConstants.github)!
    }
}
