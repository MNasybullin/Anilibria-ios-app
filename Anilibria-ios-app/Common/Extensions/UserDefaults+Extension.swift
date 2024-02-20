//
//  UserDefaults+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.10.2023.
//

import UIKit

enum UserDefaultsKeys: String {
    case isUserAuthorized
    case userLogin
    
    case appearance
    
    // VideoPlayer
    case ambientMode
}

extension UserDefaults {
    var isUserAuthorized: Bool {
        get {
            bool(forKey: UserDefaultsKeys.isUserAuthorized.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.isUserAuthorized.rawValue)
        }
    }
    
    var userLogin: String? {
        get {
            string(forKey: UserDefaultsKeys.userLogin.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userLogin.rawValue)
        }
    }
    
    var appearance: UIUserInterfaceStyle {
        get {
            UIUserInterfaceStyle(rawValue: integer(forKey: UserDefaultsKeys.appearance.rawValue)) ?? .unspecified
        }
        set {
            set(newValue.rawValue, forKey: UserDefaultsKeys.appearance.rawValue)
        }
    }
}


// MARK: - VideoPlayer

extension UserDefaults {
    var ambientMode: Bool {
        get {
            bool(forKey: UserDefaultsKeys.ambientMode.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.ambientMode.rawValue)
        }
    }
}
