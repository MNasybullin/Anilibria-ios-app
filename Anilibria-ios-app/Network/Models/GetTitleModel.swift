//
//  GetTitleModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.07.2022.
//

// swiftlint:disable identifier_name

import Foundation

/// Возвращается в запросах:
/// getTitle, getTitles, getUpdates, getChanges, getRandomTitle, getFavorites
/// - Prefix `GT` = GetTitle
struct GetTitleModel: Codable {
    let id: Int
    let code: String
    let names: GTNames
    let announce: String?
    let status: GTStatus?
    let posters: GTPosters?
    let updated: Int?
    let lastChange: Int?
    let type: GTType?
    let genres: [String]?
    let team: GTTeam?
    let season: GTSeason?
    let description: String?
    let inFavorites: Int?
    let blocked: GTBlocked?
    let player: GTPlayer?
    // GTTorrents не реализованно скачивание по торренту.
//    let torrents: GTTorrents
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case names
        case announce
        case status
        case posters
        case updated
        case lastChange = "last_change"
        case type
        case genres
        case team
        case season
        case description
        case inFavorites = "in_favorites"
        case blocked
        case player
    }
}

struct GTNames: Codable {
    let ru: String
    let en: String?
    let alternative: String?
}

struct GTStatus: Codable {
    let string: String?
    let code: Int?
}

struct GTPosters: Codable {
    let small: GTPoster?
    let medium: GTPoster?
    let original: GTPoster?
}

struct GTPoster: Codable {
    let url: String?
}

struct GTType: Codable {
    let fullString: String?
    let code: Int?
    let string: String?
    let series: Int?
    let length: Int?
    
    enum CodingKeys: String, CodingKey {
        case fullString = "full_string"
        case code
        case string
        case series
        case length
    }
}

struct GTTeam: Codable {
    let voice: [String]?
    let translator: [String]?
    let editing: [String]?
    let decor: [String]?
    let timing: [String]?
}

struct GTSeason: Codable {
    let string: String?
    let code: Int?
    let year: Int?
    let weekDay: Int?
    
    enum CodingKeys: String, CodingKey {
        case string
        case code
        case year
        case weekDay = "week_day"
    }
}

struct GTBlocked: Codable {
    let blocked: Bool?
    let bakanim: Bool?
}

struct GTPlayer: Codable {
    let alternativePlayer: String?
    let host: String?
    let series: GTSeries?
    let playlist: [GTPlaylist]?
    
    enum CodingKeys: String, CodingKey {
        case alternativePlayer = "alternative_player"
        case host
        case series
        case playlist
    }
}

struct GTSeries: Codable {
    let first: Double?
    let last: Double?
    let string: String?
}

struct GTPlaylist: Codable {
    let serie: Double?
    let createdTimestamp: Int?
    let preview: String?
    let skips: GTSkips?
    let hls: GTHls?
    
    enum CodingKeys: String, CodingKey {
        case serie
        case createdTimestamp = "created_timestamp"
        case preview
        case skips
        case hls
    }
}

struct GTHls: Codable {
    let fhd: String?
    let hd: String?
    let sd: String?
}

struct GTSkips: Codable {
    let opening: [Double?]
    let ending: [Double?]
}

/*
struct GTTorrents: Codable {
    let series: GTSeries?
    let list: [GTList]
}

struct GTList: Codable {
    let torrent_id: Int
    let series: GTSeries
    let quality: GTQuality
    let leechers: Int
    let seeders: Int
    let downloads: Int
    let total_size: Int
    let url: String
    let uploaded_timestamp: Int
}

struct GTQuality: Codable {
    let string: String
    let type: String
    let resolution: String
    let encoder: String
    let lq_audio: String?
}
*/
