//
//  AboutAppModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.02.2024.
//

import Foundation

final class AboutAppModel {
    func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    func getGithubURL() -> URL {
        URL(string: NetworkConstants.github)!
    }
}
