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
        case playerNoData(
            animeId: Int,
            numberOfEpisode: Float,
            presentatingController: UIViewController
        )
        case episodes(
            data: AnimeItem,
            currentPlaylistNumber: Int,
            completionBlock: (Int) -> Void,
            presentatingController: UIViewController
        )
        case settings(
            hls: [HLS],
            currentHLS: HLS,
            rate: PlayerRate,
            presentatingController: UIViewController,
            delegate: VideoPlayerSettingsControllerDelegate
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
            case .playerNoData(let animeId, let numberOfEpisode, let presentatingController):
                setupAndShowPlayerNoData(
                    animeId: animeId,
                    numberOfEpisode: numberOfEpisode,
                    presentatingController: presentatingController
                )
            case .episodes(let data, let currentPlaylistNumber, let completionBlock, let presentatingController):
                setupAndShowEpisodes(
                    data: data,
                    currentPlaylistNumber: currentPlaylistNumber,
                    completionBlock: completionBlock,
                    presentatingController: presentatingController
                )
            case .settings(let hls, let currentHLS, let rate, let presentatingController, let delegate):
                setupAndShowSettings(hls: hls, currentHLS: currentHLS, rate: rate, presentatingController: presentatingController, delegate: delegate)
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
        player.modalPresentationStyle = .fullScreen
        player.modalPresentationCapturesStatusBarAppearance = true
        presentatingController.present(player, animated: true)
    }
    
    func setupAndShowPlayerNoData(animeId: Int, numberOfEpisode: Float, presentatingController: UIViewController) {
        dissmisPlayerController()
        let player = VideoPlayerController(
            animeId: animeId,
            numberOfEpisode: numberOfEpisode
        )
        player.navigator = self
        player.modalPresentationStyle = .fullScreen
        player.modalPresentationCapturesStatusBarAppearance = true
        presentatingController.present(player, animated: true)
    }
    
    func setupAndShowEpisodes(data: AnimeItem, currentPlaylistNumber: Int, completionBlock: @escaping (Int) -> Void, presentatingController: UIViewController) {
        let episodes = VideoPlayerEpisodesController(
            data: data,
            currentPlaylistNumber: currentPlaylistNumber,
            completionBlock: completionBlock
        )
        let navigationController = UINavigationController(rootViewController: episodes)
        navigationController.navigationBar.standardAppearance.configureWithOpaqueBackground()
        if let sheetController = navigationController.sheetPresentationController {
            sheetController.detents = [.large()]
            sheetController.prefersGrabberVisible = true
            sheetController.prefersEdgeAttachedInCompactHeight = true
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        presentatingController.present(navigationController, animated: true)
    }
    
    func setupAndShowSettings(hls: [HLS], currentHLS: HLS, rate: PlayerRate, presentatingController: UIViewController, delegate: VideoPlayerSettingsControllerDelegate) {
        let settings = VideoPlayerSettingsController(hls: hls, currentHLS: currentHLS, rate: rate)
        settings.delegate = delegate
        let navigationController = UINavigationController(rootViewController: settings)
        navigationController.navigationBar.standardAppearance.configureWithOpaqueBackground()
        if let sheetController = navigationController.sheetPresentationController {
            sheetController.detents = [.medium(), .large()]
            sheetController.prefersGrabberVisible = true
            sheetController.prefersEdgeAttachedInCompactHeight = true
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        presentatingController.present(navigationController, animated: true)
    }
}
