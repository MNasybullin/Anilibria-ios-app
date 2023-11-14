//
//  AnimeNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

protocol AnimeFlow: AnyObject {
    /// use weak !
    var navigator: AnimeNavigator? { get set }
}

final class AnimeNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - BasicNavigator

extension AnimeNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension AnimeNavigator: Navigator {
    enum Destinition {
        case series(data: AnimeItem)
        case videoPlayer(data: AnimeItem, currentPlaylist: Int)
    }
    
    func show(_ destination: Destinition) {
        switch destination {
            case .series(let data):
                let series = SeriesController(data: data)
                series.title = data.ruName
                series.navigator = self
                navigationController.pushViewController(series, animated: true)
            case .videoPlayer(let item, let currentPlaylist):
                let playerNavigator = VideoPlayerNavigator.shared
                playerNavigator.show(.player(data: item, currentPlaylist: currentPlaylist, presentatingController: navigationController))
        }
    }
}
