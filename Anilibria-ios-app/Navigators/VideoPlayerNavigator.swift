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
    
    /// For PIP
    var playerController: VideoPlayerController?
    
    /// When PIP is active
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
        case series(
            data: AnimeItem,
            currentPlaylistNumber: Int,
            completionBlock: (Int) -> Void,
            presentatingController: UIViewController
        )
    }
    
    func show(_ destination: Destinition) {
        switch destination {
            case .player(let item, let currentPlaylist, let presentatingController):
                setupAndShowPlayer(
                    item: item,
                    currentPlaylist: currentPlaylist,
                    presentatingController: presentatingController
                )
            case .series(let data, let currentPlaylistNumber, let completionBlock, let presentatingController):
                setupAndShowSeries(
                    data: data,
                    currentPlaylistNumber: currentPlaylistNumber,
                    completionBlock: completionBlock,
                    presentatingController: presentatingController
                )
        }
    }
}

// MARK: - Private methods

private extension VideoPlayerNavigator {
    func setupAndShowPlayer(item: AnimeItem, currentPlaylist: Int, presentatingController: UIViewController) {
        dissmisPlayerController()
        let player = VideoPlayerController(
            animeItem: item,
            currentPlaylist: currentPlaylist
        )
        player.navigator = self
        player.modalPresentationStyle = .overFullScreen
        player.modalPresentationCapturesStatusBarAppearance = true
        presentatingController.present(player, animated: true)
    }
    
    func setupAndShowSeries(data: AnimeItem, currentPlaylistNumber: Int, completionBlock: @escaping (Int) -> Void, presentatingController: UIViewController) {
        let series = VideoPlayerSeriesController(
            data: data,
            currentPlaylistNumber: currentPlaylistNumber,
            completionBlock: completionBlock
        )
        let navigationController = UINavigationController(rootViewController: series)
        navigationController.navigationBar.standardAppearance.configureWithOpaqueBackground()
        if let sheetController = navigationController.sheetPresentationController {
            sheetController.detents = [.large()]
            sheetController.prefersGrabberVisible = true
            sheetController.prefersEdgeAttachedInCompactHeight = true
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        presentatingController.present(navigationController, animated: true)
    }
}
