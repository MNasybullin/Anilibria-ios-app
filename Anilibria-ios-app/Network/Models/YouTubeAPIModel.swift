//
//  YouTubeAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 23.07.2022.
//

import Foundation

/// Возвращается в запросах:
/// getYouTube
struct YouTubeAPIModel: Decodable {
    let id: Int
    let title: String
    let image: String
    let youtubeId: String
    let timestamp: Int
}
