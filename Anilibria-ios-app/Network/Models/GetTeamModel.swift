//
//  GetTeamModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.02.2023.
//

import Foundation

/// Возвращается в запросах:
/// getTeam
struct GetTeamModel: Codable {
    let team: GTMTeamModel?
}

struct GTMTeamModel: Codable {
    let voice: [String]?
    let translator: [String]?
    let editing: [String]?
    let decor: [String]?
    let timing: [String]?
}
