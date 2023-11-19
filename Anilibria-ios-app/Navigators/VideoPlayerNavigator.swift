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
        
    var playerController: VideoPlayerController?
    
    private func dissmisPlayerController() {
        playerController?.dismiss(animated: true)
        playerController = nil
    }
}

// MARK: - Navigator

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
                setupAndShowPlayer(
                    item: item,
                    currentPlaylist: currentPlaylist,
                    presentatingController: presentatingController
                )
            case .series(let data):
                setupAndShowSeries(data: data)
        }
    }
    
    private func setupAndShowPlayer(item: AnimeItem, currentPlaylist: Int, presentatingController: UIViewController) {
        dissmisPlayerController()
        let player = VideoPlayerController(
            animeItem: item,
            currentPlaylist: currentPlaylist
        )
        player.navigator = self
        playerController = player
        player.modalPresentationStyle = .overFullScreen
        presentatingController.present(player, animated: true)
    }
    
    private func setupAndShowSeries(data: AnimeItem) {
        let series = SeriesController(data: data)
        if let sheetController = series.sheetPresentationController {
            sheetController.detents = [.large()]
            sheetController.prefersGrabberVisible = true
            sheetController.prefersEdgeAttachedInCompactHeight = true
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        playerController?.present(series, animated: true)
    }
}
