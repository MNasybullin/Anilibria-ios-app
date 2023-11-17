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
        super.viewWillTransition(to: size, with: coordinator)
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
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        showsPlaybackControls = false
        
        overlayView.delegate = self
        overlayView.topViewDelegate = self
        overlayView.middleViewDelegate = self
        overlayView.bottomViewDelegate = self
        overlayView.routePickerViewDelegate = self
        
        overlayView.setTitle(model.getTitle())
        overlayView.setSubtitle(model.getSubtitle())
    }
    
    func configureVideoPlayer() {
        player = AVPlayer()
        if #available(iOS 16.0, *) {
            allowsVideoFrameAnalysis = false
        }
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
                        print("STATUS = readyToPlay")
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
        if overlayView.isOverlaysHidden {
            overlayView.showOverlay()
        } else {
            overlayView.hideOverlay()
        }
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
        guard let duration = player?.currentItem?.duration else { return }
        let targetTime = max(.zero, player!.currentTime() - CMTime(seconds: 10, preferredTimescale: duration.timescale))
        player?.seek(to: targetTime)
    }
    
    func playPauseButtonDidTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func forwardButtonDidTapped() {
        guard let duration = player?.currentItem?.duration else { return }
        let targetTime = min(duration, player!.currentTime() + CMTime(seconds: 10, preferredTimescale: duration.timescale))
        player?.seek(to: targetTime)
    }
}

// MARK: - BottomOverlayViewDelegate

extension VideoPlayerController: BottomOverlayViewDelegate {
    func seriesButtonDidTapped() {
        let data = model.getData()
        navigator?.show(.series(data: data))
    }
}

extension VideoPlayerController: AVRoutePickerViewDelegate {
    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
    }
    
//    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
//        <#code#>
//    }
}
