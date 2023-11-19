//
//  AnimeItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

struct AnimeItem {
    var image: UIImage?
    let ruName: String
    let engName: String?
    let seasonAndType: String
    let genres: String?
    let description: String?
    let series: GTSeries?
    let playlist: [Playlist]
}

extension AnimeItem {
    init (fromTitleApiModel item: TitleAPIModel) {
        let playlist = item.player?.playlist?.map { Playlist(fromGTPlaylist: $0) }
        
        self.init(
            ruName: item.names.ru,
            engName: item.names.en,
            seasonAndType: AnimeItem.getSeasonAndTypeText(item),
            genres: AnimeItem.getgenresText(item),
            description: AnimeItem.getDescriptionText(item),
            series: item.player?.series,
            playlist: playlist ?? [Playlist]())
    }
    
    private static func getSeasonAndTypeText(_ model: TitleAPIModel) -> String {
        let year = model.season?.year?.description == nil ? "" : (model.season?.year?.description)! + " "
        let season = model.season?.string == nil ? "" : (model.season?.string)! + ", "
        let type = model.type?.fullString ?? ""
        return year + season + type
    }
    
    private static func getgenresText(_ model: TitleAPIModel) -> String? {
        return model.genres?.joined(separator: ", ")
    }
    
    private static func getDescriptionText(_ model: TitleAPIModel) -> String? {
        return model.description?.replacingOccurrences(of: "[\r\n]{3,}", with: "\n\n", options: .regularExpression, range: nil)
    }
}
