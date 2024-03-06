//
//  SettingsModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsModel {
    private let userDefaults = UserDefaults.standard
    
    var appearance: UIUserInterfaceStyle {
        get { userDefaults.appearance }
        set {
            userDefaults.appearance = newValue
            applyAppearance()
        }
    }
    
    var ambientMode: Bool {
        get { userDefaults.ambientMode }
        set { userDefaults.ambientMode = newValue }
    }
    
}

// MARK: - Private methods

private extension SettingsModel {
    func applyAppearance() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.applyAppearance()
        }
    }
}
