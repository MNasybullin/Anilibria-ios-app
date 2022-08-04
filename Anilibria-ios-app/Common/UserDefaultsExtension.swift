//
//  UserDefaultsExtension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.08.2022.
//

import Foundation

extension UserDefaults {
    func setSessionId(_ sessionId: String?) {
        set(sessionId, forKey: "SessionId")
    }
    
    func getSessionId() -> String? {
        return string(forKey: "SessionId")
    }
}
