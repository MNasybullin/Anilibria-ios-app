//
//  FranchisesAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import Foundation

struct FranchisesAPIModel: Decodable {
    let franchise: Franchise
    let releases: [FranchiseReleases]
}

struct Franchise: Decodable {
    let id: String
    let name: String
}

struct FranchiseReleases: Decodable {
    let id: Int
    let code: String
    let ordinal: Int
    let names: GTNames
}
