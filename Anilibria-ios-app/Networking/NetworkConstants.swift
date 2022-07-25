//
//  NetworkConstants.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation

enum MyNetworkingError: Error {
    case invalidServerResponse
    case invalidURLComponents
}

enum NetworkConstants {
    static let baseAnilibriaURL = "https://api.anilibria.tv"
}
