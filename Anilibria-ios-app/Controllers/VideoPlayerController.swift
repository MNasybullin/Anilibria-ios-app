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
    private var timeObserverToken: Any?
    
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
        
//        overlayView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            overlayView.topAnchor.constraint(equalTo: contentOverlayView.topAnchor),
//            overlayView.leadingAnchor.constraint(equalTo: contentOverlayView.leadingAnchor),
//            overlayView.trailingAnchor.constraint(equalTo: contentOverlayView.trailingAnchor),
//            overlayView.bottomAnchor.constraint(equalTo: contentOverlayView.bottomAnchor)
//        ])
        
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
        addPeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player!.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self,
                  let currentItem = player?.currentItem,
                  currentItem.status == .readyToPlay else {
                return
            }
            
            overlayView.setPlaybackSlider(value: Float(time.seconds))
            let leftTime = self.stringFromTimeInterval(interval: time.seconds)
            overlayView.setLeftTime(text: leftTime)
            let durationFloat = Float64(CMTimeGetSeconds(currentItem.duration))
            let rightTime = self.stringFromTimeInterval(interval: durationFloat - time.seconds)
            overlayView.setRightTime(text: "-" + rightTime)
            
            if currentItem.isPlaybackLikelyToKeepUp == false {
                overlayView.showActivityIndicator()
            } else {
                overlayView.hideActivityIndicator()
            }
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func playVideo() {
        overlayView.showOverlay()
        overlayView.hideActivityIndicator()
        player?.play()
    }
    
    @objc func finishedPlaying( _ myNotification: NSNotification) {
        print(#function)
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
                        let duration = Float(CMTimeGetSeconds(playerItem.duration))
                        overlayView.setPlaybackSlider(duration: duration)
                        
                        playVideo()
                    case .failed:
                        print("STATUS = failed")
                    default:
                        break
                }
            }
            .store(in: &subscriptions)
        
        player?.replaceCurrentItem(with: playerItem)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.finishedPlaying(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
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
    func playbackSliderDidChanged(_ slider: UISlider, event: UIEvent) {
        let leftTime = stringFromTimeInterval(interval: TimeInterval(slider.value))
        overlayView.setLeftTime(text: leftTime)
        
        let seconds = Int64(slider.value)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
                case .moved:
                    player!.seek(to: targetTime)
                case .ended:
                    player!.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
                default:
                    break
            }
        }
    }
    
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
