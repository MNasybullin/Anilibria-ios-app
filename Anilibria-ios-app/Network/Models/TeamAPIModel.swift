//
//  TeamAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.02.2023.
//

import Foundation

/// Возвращается в запросах:
/// team
struct TeamAPIModel: Decodable {
    let voice: [String]
    let translator: [String]
    let editing: [String]
    let decor: [String]
    let timing: [String]
}
