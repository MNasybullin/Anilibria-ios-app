//
//  VideoPlayerNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.11.2023.
//

import UIKit

protocol VideoPlayerFlow: AnyObject {
    /// use weak !
    var navigator: VideoPlayerNavigator? { get set }
}

final class VideoPlayerNavigator {
    static let shared = VideoPlayerNavigator()
    
    private weak var playerController: VideoPlayerController?
    
    private func dissmisPlayerController() {
        playerController?.player?.pause()
        playerController?.player = nil
        playerController?.dismiss(animated: true)
        playerController = nil
    }
}

extension VideoPlayerNavigator: Navigator {
    enum Destinition {
        case player(
            data: AnimeItem,
            currentPlaylist: Int,
            presentatingController: UIViewController
        )
        case series(data: AnimeItem)
    }
    
    func show(_ destination: Destinition) {
        switch destination {
            case .player(let item, let currentPlaylist, let presentatingController):
                dissmisPlayerController()
                let player = VideoPlayerController(
                    animeItem: item,
                    currentPlaylist: currentPlaylist
                )
                player.navigator = self
                playerController = player
                presentatingController.present(player, animated: true)
            case .series(let data):
                let series = SeriesController(data: data)
                playerController?.present(series, animated: true)
        }
    }
}
