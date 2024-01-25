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
        case episodes(data: AnimeItem)
        case videoPlayer(data: AnimeItem, currentPlaylist: Int)
    }
    
    func show(_ destination: Destinition) {
        switch destination {
            case .episodes(let data):
                let episodes = EpisodesController(data: data)
                episodes.title = data.ruName
                episodes.navigator = self
                navigationController.pushViewController(episodes, animated: true)
            case .videoPlayer(let item, let currentPlaylist):
                let playerNavigator = VideoPlayerNavigator.shared
                playerNavigator.show(.player(data: item, currentPlaylist: currentPlaylist, presentatingController: navigationController))
        }
    }
}
