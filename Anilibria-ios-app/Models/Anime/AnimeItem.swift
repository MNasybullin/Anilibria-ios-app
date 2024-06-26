//
//  AnimeItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

struct AnimeItem {
    var id: Int
    var image: UIImage?
    let ruName: String
    let code: String
    let engName: String?
    let seasonAndType: String
    let status: String
    let genres: String?
    let team: [Team]
    let description: String?
    let host: String?
    let episodes: GTEpisodes?
    let playlist: [Playlist]
    let blocked: Bool
}

extension AnimeItem {
    init(fromTitleApiModel item: TitleAPIModel, image: UIImage?) {
        let playlist = item.player?.list?.map { Playlist(fromGTPlaylist: $0) }
        self.init(
            id: item.id,
            image: image,
            ruName: item.names.ru,
            code: item.code,
            engName: item.names.en,
            seasonAndType: Self.getSeasonAndTypeText(item),
            status: Self.getStatus(item),
            genres: Self.getgenresText(item.genres),
            team: Self.convertToTeam(from: item.team),
            description: Self.getDescriptionText(item.description),
            host: item.player?.host,
            episodes: item.player?.episodes.data,
            playlist: playlist ?? [Playlist](),
            blocked: Self.getBlocked(from: item.blocked)
        )
    }
    
    private static func getSeasonAndTypeText(_ model: TitleAPIModel) -> String {
        let year = model.season?.year?.description == nil ? "" : (model.season?.year?.description)! + " "
        let season = model.season?.string == nil ? "" : (model.season?.string)! + ", "
        let type = model.type?.fullString ?? ""
        return year + season + type
    }
    
    private static func getStatus(_ model: TitleAPIModel) -> String {
        model.status?.string ?? Strings.AnimeItem.noData
    }
    
    private static func getgenresText(_ genres: [String]?) -> String? {
        return genres?.joined(separator: ", ")
    }
    
    private static func getDescriptionText(_ description: String?) -> String? {
        return ("\t" + (description ?? ""))
            .replacingOccurrences(of: "[\r\n]{3,}", with: "\n\n", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "[\n]", with: "\n\t", options: .regularExpression, range: nil)
    }
    
    private static func convertToTeam(from gtTeam: GTTeam?) -> [Team] {
        var teams: [Team] = []
        if let voice = gtTeam?.voice, !voice.isEmpty {
            teams.append(.voice(voice))
        }
        if let translator = gtTeam?.translator, !translator.isEmpty {
            teams.append(.translator(translator))
        }
        if let editing = gtTeam?.editing, !editing.isEmpty {
            teams.append(.editing(editing))
        }
        if let decor = gtTeam?.decor, !decor.isEmpty {
            teams.append(.decor(decor))
        }
        if let timing = gtTeam?.timing, !timing.isEmpty {
            teams.append(.timing(timing))
        }
        return teams
    }
    
    private static func getBlocked(from data: GTBlocked?) -> Bool {
        guard let data else {
            return false
        }
        return data.blocked ?? false || data.bakanim ?? false
    }
}
