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
    var image: UIImage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(watchingDate)
    }
    
    static func == (lhs: HomeWatchingItem, rhs: HomeWatchingItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.watchingDate == rhs.watchingDate
    }
}
