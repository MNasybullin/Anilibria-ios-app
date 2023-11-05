//
//  SeriesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import Foundation

final class SeriesModel: ImageModel {
    private var animeItem: AnimeItem
    
    init(animeItem: AnimeItem) {
        self.animeItem = animeItem
    }
}

extension SeriesModel {
    func getData() -> [Playlist] {
        return animeItem.playlist
    }
    
    func getSeriesDescription() -> String? {
        return animeItem.series?.string
    }
}
