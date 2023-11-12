//
//  UserDefaults+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.10.2023.
//

import Foundation

enum UserDefaultsKeys: String {
    case isUserAuthorized
}

extension UserDefaults {
    var isUserAuthorized: Bool {
        get {
            bool(forKey: UserDefaultsKeys.isUserAuthorized.rawValue)
        }
        set {
            set(newValue, 
                forKey: UserDefaultsKeys.isUserAuthorized.rawValue)
        }
    }
}
