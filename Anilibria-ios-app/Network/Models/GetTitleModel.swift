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
struct GetTitleModel: Decodable {
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
}

struct GTNames: Decodable {
    let ru: String
    let en: String?
    let alternative: String?
}

struct GTStatus: Decodable {
    let string: String?
    let code: Int?
}

struct GTPosters: Decodable {
    let small: GTPoster?
    let medium: GTPoster?
    let original: GTPoster?
}

struct GTPoster: Decodable {
    let url: String?
}

struct GTType: Decodable {
    let fullString: String?
    let code: Int?
    let string: String?
    let series: Int?
    let length: Int?
}

struct GTTeam: Decodable {
    let voice: [String]?
    let translator: [String]?
    let editing: [String]?
    let decor: [String]?
    let timing: [String]?
}

struct GTSeason: Decodable {
    let string: String?
    let code: Int?
    let year: Int?
    let weekDay: Int?
}

struct GTBlocked: Decodable {
    let blocked: Bool?
    let bakanim: Bool?
}

struct GTPlayer: Decodable {
    let alternativePlayer: String?
    let host: String?
    let series: GTSeries?
    let playlist: [GTPlaylist]?
}

struct GTSeries: Decodable {
    let first: Double?
    let last: Double?
    let string: String?
}

struct GTPlaylist: Decodable {
    let serie: Double?
    let createdTimestamp: Int?
    let preview: String?
    let skips: GTSkips?
    let hls: GTHls?
}

struct GTHls: Decodable {
    let fhd: String?
    let hd: String?
    let sd: String?
}

struct GTSkips: Decodable {
    let opening: [Double?]
    let ending: [Double?]
}

/*
struct GTTorrents: Decodable {
    let series: GTSeries?
    let list: [GTList]
}

struct GTList: Decodable {
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

struct GTQuality: Decodable {
    let string: String
    let type: String
    let resolution: String
    let encoder: String
    let lq_audio: String?
}
*/
