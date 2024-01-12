//
//  Team.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.12.2023.
//

import Foundation

enum Team {
    case voice ([String])
    case translator ([String])
    case editing ([String])
    case decor ([String])
    case timing ([String])
    
    var nicknames: [String] {
        switch self {
            case .voice(let nicknames):
                return nicknames
            case .translator(let nicknames):
                return nicknames
            case .editing(let nicknames):
                return nicknames
            case .decor(let nicknames):
                return nicknames
            case .timing(let nicknames):
                return nicknames
        }
    }
}

extension Team: CustomStringConvertible {
    var description: String {
        switch self {
            case .voice:
                return Strings.Team.voice
            case .translator:
                return Strings.Team.translator
            case .editing:
                return Strings.Team.editing
            case .decor:
                return Strings.Team.decor
            case .timing:
                return Strings.Team.timing
        }
    }
}
