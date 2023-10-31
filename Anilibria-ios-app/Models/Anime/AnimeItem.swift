//
//  AnimeItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

struct AnimeItem {
    var image: UIImage?
    var ruName: String
    var engName: String?
    var seasonAndType: String
    var genres: String?
    var description: String?
    var series: GTSeries?
    var playlist: [Playlist]
}

struct Playlist {
    let serie: Double?
    let serieString: String
    let createdTimestamp: Int?
    let createdDateString: String
    let preview: String?
    var image: UIImage?
    var imageIsLoading: Bool = false
    let skips: GTSkips?
    let hls: GTHls?
}
