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
    let status: GTStatus
    let posters: GTPosters
    let updated: Int
    let last_change: Int
    let type: GTType
    let genres: [String]
    let team: GTTeam
    let season: GTSeason
    let description: String
    let in_favorites: Int
    let blocked: GTBlocked
    let player: GTPlayer
    // GTTorrents не реализованно скачивание по торренту.
//    let torrents: GTTorrents
}

struct GTNames: Codable {
    let ru: String
    let en: String
    let alternative: String?
}

struct GTStatus: Codable {
    let string: String
    let code: Int
}

struct GTPosters: Codable {
    let small: GTPoster
    let medium: GTPoster
    let original: GTPoster
}

struct GTPoster: Codable {
    let url: String
}

struct GTType: Codable {
    let full_string: String
    let code: Int
    let string: String
    let series: Int?
    let length: Int?
}

struct GTTeam: Codable {
    let voice: [String]
    let translator: [String]
    let editing: [String]
    let decor: [String]
    let timing: [String]
}

struct GTSeason: Codable {
    let string: String
    let code: Int
    let year: Int
    let week_day: Int
}

struct GTBlocked: Codable {
    let blocked: Bool
    let bakanim: Bool
}

struct GTPlayer: Codable {
    let alternative_player: String?
    let host: String?
    let series: GTSeries?
    let playlist: [GTPlaylist]?
}

struct GTSeries: Codable {
    let first: Int
    let last: Int
    let string: String
}

struct GTPlaylist: Codable {
    let serie: Double
    let created_timestamp: Int
    let hls: GTHls
}

struct GTHls: Codable {
    let fhd: String?
    let hd: String?
    let sd: String?
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
