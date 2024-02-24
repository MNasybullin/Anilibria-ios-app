//
//  TitleAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.07.2022.
//

import Foundation

/// Возвращается в запросах:
/// title, title/list, title/random
/// - Prefix `GT` = GetTitle
struct TitleAPIModel: Decodable {
    let id: Int
    let code: String
    let names: GTNames
    let franchises: [FranchisesAPIModel]
    let announce: String?
    let status: GTStatus?
    let posters: GTPosters
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
    let original: GTPoster
}

struct GTPoster: Decodable {
    let url: String
}

struct GTType: Decodable {
    let fullString: String?
    let code: Int?
    let string: String?
    let episodes: Int?
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
    let episodes: GTEpisodesResponse
    let list: [GTPlaylist]?
}

// Так как иногда с сервера может прийти массив, вместо объекта :/
enum GTEpisodesResponse: Decodable {
    case singleEpisode(GTEpisodes?)
    case episodeArray([GTEpisodes])
    
    var data: GTEpisodes? {
        switch self {
            case .singleEpisode(let data):
                return data
            case .episodeArray(let data):
                return data.first
        }
    }

    init(from decoder: Decoder) throws {
        if let singleEpisode = try? GTEpisodes(from: decoder) {
            self = .singleEpisode(singleEpisode)
        } else if let episodeArray = try? [GTEpisodes](from: decoder) {
            self = .episodeArray(episodeArray)
        } else {
            throw DecodingError.typeMismatch(GTEpisodesResponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode GTEpisodesResponse"))
        }
    }
}

struct GTEpisodes: Decodable {
    let first: Double?
    let last: Double?
    let string: String?
}

struct GTPlaylist: Decodable {
    let episode: Float?
    let name: String?
    let uuid: String?
    let createdTimestamp: Int?
    let preview: String?
    let skips: GTSkips
    let hls: GTHls
}

struct GTHls: Decodable {
    let fhd: String?
    let hd: String?
    let sd: String?
}

struct GTSkips: Decodable {
    let opening: [Double]
    let ending: [Double]
}
