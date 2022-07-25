//
//  GetYouTubeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 23.07.2022.
//

import Foundation

/// Используется в запросах:
/// getYouTube
struct GetYouTubeModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case youTubeId = "youtube_id"
        case timeStamp = "timestamp"
    }
    
    let id: Int
    let title: String
    let image: String
    let youTubeId: String
    let timeStamp: Int
}
