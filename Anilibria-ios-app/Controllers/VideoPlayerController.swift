//
//  VideoPlayerController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.11.2023.
//

import AVKit
import Combine

final class VideoPlayerController: AVPlayerViewController, VideoPlayerFlow {
    weak var navigator: VideoPlayerNavigator?
    
    private let overlayView = VideoPlayerOverlayView()
    private let model: VideoPlayerModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        model = VideoPlayerModel(animeItem: animeItem, currentPlaylist: currentPlaylist)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        model.delegate = self
        configureOverlay()
        configureVideoPlayer()
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
    
    func configureVideoPlayer() {
        player = AVPlayer()
    }
    
    func playVideo() {
        overlayView.showOverlay()
        overlayView.hideActivityIndicator()
        player?.play()
    }
}

// MARK: - Internal methods

extension VideoPlayerController {
    
}

// MARK: - AVPlayerViewControllerDelegate

extension VideoPlayerController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        MainNavigator.shared.rootViewController.present(playerViewController, animated: false) {
            completionHandler(true)
        }
    }
}

// MARK: - VideoPlayerModelDelegate

extension VideoPlayerController: VideoPlayerModelDelegate {
    func configurePlayerItem(url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(
            asset: asset,
            automaticallyLoadedAssetKeys: [.tracks, .duration, .commonMetadata]
        )
        
        playerItem.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                    case .readyToPlay:
                        print("STATUS = readyToPly")
                        playVideo()
                    case .failed:
                        print("STATUS = failed")
                    default:
                        print("STATUS = default = ", status)
                }
            }
            .store(in: &subscriptions)
        
        player?.replaceCurrentItem(with: playerItem)
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
        dismiss(animated: true)
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
