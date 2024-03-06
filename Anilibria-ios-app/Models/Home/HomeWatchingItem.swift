//
//  HomeWatchingItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.02.2024.
//

import UIKit

struct HomeWatchingItem: Hashable {
    let id: Int
    let title: String
    let subtitle: String
    let watchingDate: Date
    let duration: Double
    let numberOfEpisode: Float
    let playbackPosition: Double
    let image: UIImage
}
