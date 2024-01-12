//
//  UserDefaults+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.10.2023.
//

import Foundation

enum UserDefaultsKeys: String {
    case isUserAuthorized
    case userId
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
    
    var userId: Int? {
        get {
            let value = integer(forKey: UserDefaultsKeys.userId.rawValue)
            return value != 0 ? value : nil
        }
        set {
            set(newValue ?? 0,
                forKey: UserDefaultsKeys.userId.rawValue)
        }
    }
}
