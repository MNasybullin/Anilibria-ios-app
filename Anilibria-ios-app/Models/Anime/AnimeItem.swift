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

struct Playlist {
    let serie: Double?
    let serieString: String
    let createdTimestamp: Int?
    let createdDateString: String
    let preview: String
    var image: UIImage?
    let skips: GTSkips?
    let hls: GTHls?
}
