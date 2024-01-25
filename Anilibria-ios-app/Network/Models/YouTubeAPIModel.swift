//
//  YouTubeAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 23.07.2022.
//

import Foundation

/// Возвращается в запросах:
/// youtube
struct YouTubeAPIModel: Decodable {
    let id: Int
    let title: String
    let preview: YouTubePreview
    let youtubeId: String
    let comments: Int
    let views: Int
    let timestamp: Int
}

struct YouTubePreview: Decodable {
    let src: String
    let thumbnail: String
}
