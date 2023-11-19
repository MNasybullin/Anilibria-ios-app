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

// MARK: - Internal methods

extension SeriesModel {
    func getPlaylists() -> [Playlist] {
        return animeItem.playlist
    }
    
    func getAnimeItem() -> AnimeItem {
        return animeItem
    }
    
    func getSeriesDescription() -> String? {
        return animeItem.series?.string
    }
}
