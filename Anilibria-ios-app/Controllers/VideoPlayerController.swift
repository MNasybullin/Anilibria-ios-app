//
//  VideoPlayerController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.11.2023.
//

import AVKit

final class VideoPlayerController: AVPlayerViewController {
    static let shared = VideoPlayerController()
    
    private var playlist: [Playlist]!
    private var currentPlaylist: Int!
    private let overlayView = VideoPlayerOverlayView()
    private let model = VideoPlayerModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        model.delegate = self
        configureOverlay()
        model.requestCachingNodes()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            if size.width > size.height {
                self.overlayView.updateConstraints(orientation: .landscape)
            } else {
                self.overlayView.updateConstraints(orientation: .portrait)
            }
        }
    }
}

// MARK: - Private methods

private extension VideoPlayerController {
    func configureOverlay() {
        guard let contentOverlayView else {
            fatalError("contentOverlayView in Video Player not found")
        }
        contentOverlayView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: contentOverlayView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentOverlayView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentOverlayView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentOverlayView.bottomAnchor)
        ])
        showsPlaybackControls = false
        
        overlayView.delegate = self
        overlayView.topViewDelegate = self
        overlayView.middleViewDelegate = self
        overlayView.bottomViewDelegate = self
    }
}

// MARK: - Internal methods

extension VideoPlayerController {
    func configure(playlist: [Playlist], currentPlaylist: Int) {
        self.playlist = playlist
        self.currentPlaylist = currentPlaylist
    }
}

// MARK: - AVPlayerViewControllerDelegate

extension VideoPlayerController: AVPlayerViewControllerDelegate {
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print(#function)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        MainNavigator.shared.rootViewController.present(playerViewController, animated: false) {
            completionHandler(true)
        }
    }
}

// MARK: - VideoPlayerModelDelegate

extension VideoPlayerController: VideoPlayerModelDelegate {
    func configurePlayer(serverUrl: String) {
        let hlsQuality = playlist[currentPlaylist].hls?.fhd!
        let url = URL(string: serverUrl + hlsQuality!)
        player = AVPlayer(url: url!)
        player?.play()
    }
}

// MARK: - VideoPlayerOverlayViewDelegate

extension VideoPlayerController: VideoPlayerOverlayViewDelegate {
    func didTapGesture() {
        print(#function)
    }
}

// MARK: - TopOverlayViewDelegate

extension VideoPlayerController: TopOverlayViewDelegate {
    func closeButtonDidTapped() {
        print(#function)
    }
    
    func pipButtonDidTapped() {
        print(#function)
    }
    
    func airPlayButtonDidTapped() {
        print(#function)
    }
    
    func settingsButtonDidTapped() {
        print(#function)
    }
}

// MARK: - MiddleOverlayViewDelegate

extension VideoPlayerController: MiddleOverlayViewDelegate {
    func backwardButtonDidTapped() {
        print(#function)
    }
    
    func playPauseButtonDidTapped() {
        print(#function)
    }
    
    func forwardButtonDidTapped() {
        print(#function)
    }
}

// MARK: - BottomOverlayViewDelegate

extension VideoPlayerController: BottomOverlayViewDelegate {
    func seriesButtonDidTapped() {
        print(#function)
    }
}
