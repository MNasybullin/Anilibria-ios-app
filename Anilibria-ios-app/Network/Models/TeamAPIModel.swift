//
//  TeamAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.02.2023.
//

import Foundation

/// Возвращается в запросах:
/// getTeam
struct TeamAPIModel: Decodable {
    let team: GTTeam?
}
