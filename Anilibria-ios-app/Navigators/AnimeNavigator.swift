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
        case anime(data: TitleAPIModel, image: UIImage?)
        case episodes(data: AnimeItem)
        case videoPlayer(data: AnimeItem, currentPlaylist: Int)
        case vkComments(data: AnimeItem)
    }
    
    func show(_ destination: Destinition) {
        switch destination {
            case .anime(let data, let image):
                let animeController = AnimeController(rawData: data, image: image, hasInteractiveTransitionController: navigationController.delegate != nil)
                animeController.navigator = self
                navigationController.pushViewController(animeController, animated: true)
            case .episodes(let data):
                let episodes = EpisodesController(data: data)
                episodes.title = data.ruName
                episodes.navigator = self
                navigationController.pushViewController(episodes, animated: true)
            case .videoPlayer(let item, let currentPlaylist):
                let playerNavigator = VideoPlayerNavigator.shared
                playerNavigator.show(.player(data: item, currentPlaylist: currentPlaylist, presentatingController: navigationController))
            case .vkComments(let data):
                let vkComments = VKCommentsController(data: data)
                vkComments.title = data.ruName
                navigationController.pushViewController(vkComments, animated: true)
        }
    }
}
