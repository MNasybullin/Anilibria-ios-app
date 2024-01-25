//
//  UserDefaults+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.10.2023.
//

import Foundation

enum UserDefaultsKeys: String {
    case isUserAuthorized
    case userLogin
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
}
