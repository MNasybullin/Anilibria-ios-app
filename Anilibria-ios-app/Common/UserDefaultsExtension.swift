//
//  UserDefaultsExtension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation
#warning("Переделать это используя Keychain")
enum UserDefaultsKeys: String {
    case sessionId
}

extension UserDefaults {
    func setSessionId(_ sessionId: String?) {
        set(sessionId, forKey: UserDefaultsKeys.sessionId.rawValue)
    }
    
    func getSessionId() -> String? {
        return string(forKey: UserDefaultsKeys.sessionId.rawValue)
    }
}
