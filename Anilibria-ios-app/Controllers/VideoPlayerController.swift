//
//  VideoPlayerController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.11.2023.
//

import AVKit
import Combine

final class VideoPlayerController: UIViewController, VideoPlayerFlow {
    weak var navigator: VideoPlayerNavigator?
    
    private lazy var player = AVPlayer()
    private lazy var playerLayer = AVPlayerLayer(player: player)
    private var pipController: AVPictureInPictureController?
    private lazy var overlayView = VideoPlayerOverlayView()
    private let model: VideoPlayerModel
    
    private var subscriptions = Set<AnyCancellable>()
    private var timeObserverToken: Any?
    private var pipPossibleObservation: NSKeyValueObservation?
    
    // MARK: LifeCycle
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        model = VideoPlayerModel(animeItem: animeItem, currentPlaylist: currentPlaylist)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupPictureInPicture()
        addPeriodicTimeObserver()
        model.delegate = self
        model.requestCachingNodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.currentOrientationMode = .allButUpsideDown
        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.currentOrientationMode = .portrait
        if #available(iOS 16.0, *) {
            UIView.performWithoutAnimation {
                setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
    }
    
    override public func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
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
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
}

// MARK: - Private methods

private extension VideoPlayerController {
    func setupView() {
        view.backgroundColor = .black
        view.layer.addSublayer(playerLayer)
        setupOverlayView()
    }
    
    func setupOverlayView() {
        overlayView.delegate = self
        overlayView.topViewDelegate = self
        overlayView.middleViewDelegate = self
        overlayView.bottomViewDelegate = self
        overlayView.routePickerViewDelegate = self
        
        overlayView.setTitle(model.getTitle())
        overlayView.setSubtitle(model.getSubtitle())
        
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupPictureInPicture() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            overlayView.setPIPButton(isHidden: true)
            return
        }
        
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        guard let pipController else {
            return
        }
        pipController.delegate = self
        
        pipPossibleObservation = pipController.observe(\AVPictureInPictureController.isPictureInPicturePossible, options: [.initial, .new]) { [weak self] _, change in
            let status = change.newValue ?? false
            self?.overlayView.setPIPButton(isHidden: !status)
        }
    }
    
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self,
                  let currentItem = player.currentItem,
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
        player.play()
    }
    
    @objc func finishedPlaying( _ myNotification: NSNotification) {
        print(#function)
    }
}

// MARK: - Internal methods

extension VideoPlayerController {
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
        
        player.replaceCurrentItem(with: playerItem)
        
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
        navigator?.playerController = nil
        dismiss(animated: true)
    }
    
    func pipButtonDidTapped() {
        pipController?.startPictureInPicture()
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
        guard let duration = player.currentItem?.duration else { return }
        let targetTime = max(.zero, player.currentTime() - CMTime(seconds: 10, preferredTimescale: duration.timescale))
        player.seek(to: targetTime)
    }
    
    func playPauseButtonDidTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func forwardButtonDidTapped() {
        guard let duration = player.currentItem?.duration else { return }
        let targetTime = min(duration, player.currentTime() + CMTime(seconds: 10, preferredTimescale: duration.timescale))
        player.seek(to: targetTime)
    }
}

// MARK: - BottomOverlayViewDelegate

extension VideoPlayerController: BottomOverlayViewDelegate {
    func playbackSliderDidChanged(_ slider: UISlider, event: UIEvent) {
        let leftTime = stringFromTimeInterval(interval: TimeInterval(slider.value))
        overlayView.setLeftTime(text: leftTime)
        
        if let duration = player.currentItem?.duration {
            let interval = duration.seconds - Double(slider.value)
            let rightTime = stringFromTimeInterval(interval: interval)
            overlayView.setRightTime(text: "-" + rightTime)
        }
        
        let seconds = Int64(slider.value)
        let targetTime = CMTimeMake(value: seconds, timescale: 1)
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
                case .moved:
                    player.seek(to: targetTime)
                case .ended:
                    player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
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
//    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
//
//    }
    
//    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
//
//    }
}

// MARK: - AVPictureInPictureControllerDelegate

extension VideoPlayerController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        overlayView.hideOverlay()
        navigator?.playerController = self
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        dismiss(animated: true)
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        navigator?.playerController = nil
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        navigator?.playerController = nil
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        guard let viewController = navigator?.playerController else {
            completionHandler(false)
            return
        }
        MainNavigator.shared.rootViewController.present(viewController, animated: false) {
            completionHandler(true)
        }
    }
}
