//
//  VideoPlayerController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.11.2023.
//

import AVKit
import Combine
import MediaPlayer

final class VideoPlayerController: UIViewController, VideoPlayerFlow, HasCustomView {
    typealias CustomView = VideoPlayerView
    
    private enum Constants {
        static let hideOverlayAfterSeconds: Double = 3.0
    }
    
    weak var navigator: VideoPlayerNavigator?
    
    private let player = AVPlayer()
    private var pipController: VideoPlayerPiPController?
    private let model: VideoPlayerModel
    private let remoteCommandCenterController = VideoPlayerRemoteCommandCenterController()
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    private var subscriptions = Set<AnyCancellable>()
    private var timeObserverToken: Any?
    
    private var nowPlayingInfo = [String: Any]()
    
    private var hideOverlayTimer: Timer?
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    private var isStatusBarHidden = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: LifeCycle
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        model = VideoPlayerModel(
            animeItem: animeItem,
            currentPlaylist: currentPlaylist
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let videoPlayerView = VideoPlayerView()
        videoPlayerView.playerView.player = player
        view = videoPlayerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupPiPController()
        addPeriodicTimeObserver()
        model.delegate = self
        model.requestCachingNodes()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setupRemoteCommandCenterController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppOrientation.updateOrientation(to: self, .allButUpsideDown, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if size.width > size.height {
                self.customView.updateConstraints(orientation: .landscape)
            } else {
                self.customView.updateConstraints(orientation: .portrait)
            }
        }
    }
    
    func willDismiss() {
        AppOrientation.updateOrientation(to: self, .portrait, animated: false)
    }
    
    deinit {
        nowPlayingInfoCenter.nowPlayingInfo = nil
    }
}

// MARK: - Setup methods

private extension VideoPlayerController {
    func setupView() {
        customView.delegate = self
        
        customView.setTitle(model.getTitle())
        customView.setSubtitle(model.getSubtitle())
        
        setupGestures()
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTappedGesture))
        customView.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchedGesture))
        customView.addGestureRecognizer(pinchGesture)
    }
    
    func setupPiPController() {
        pipController = VideoPlayerPiPController(videoPlayerController: self)
    }
    
    func setupRemoteCommandCenterController() {
        remoteCommandCenterController.setup(with: self)
    }
    
    func setupInfoCenter(duration: Float) {
        nowPlayingInfo = [
            MPMediaItemPropertyTitle: model.getTitle(),
            MPMediaItemPropertyArtist: model.getSubtitle(),
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackQueueCount: 1 as AnyObject,
            MPNowPlayingInfoPropertyPlaybackQueueIndex: 0 as AnyObject,
            MPMediaItemPropertyMediaType: MPMediaType.movie.rawValue as AnyObject
        ]
        if let image = model.getAnimeImage() {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ in
                return image
            })
        }
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
}

// MARK: VideoPlayer methods

extension VideoPlayerController {
    @objc func didTappedGesture() {
        if customView.isOverlaysHidden {
            setHideOverlayTimer()
            customView.showOverlay()
        } else {
            hideOverlayTimer?.invalidate()
            customView.hideOverlay()
        }
    }
    
    @objc func didPinchedGesture(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.state == .changed else {
            return
        }
        
        if gesture.scale < 1.0 {
            customView.playerView.playerLayer.videoGravity = .resizeAspect
        } else {
            customView.playerView.playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func configurePlayerTime(time: Float) {
        configureLeftRightTime(time: time)
        customView.setPlaybackSlider(value: time)
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(time)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    private func configureLeftRightTime(time: Float) {
        let leftTime = stringFromTimeInterval(interval: TimeInterval(time))
        customView.setLeftTime(text: leftTime)
        
        if let duration = player.currentItem?.duration {
            let interval = duration.seconds - Double(time)
            let rightTime = stringFromTimeInterval(interval: interval)
            customView.setRightTime(text: "-" + rightTime)
        }
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours == 0 {
            return String(format: "%2d:%02d", minutes, seconds)
        } else {
            return String(format: "%2d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    private func playVideo() {
        customView.showOverlay()
        customView.hideActivityIndicator()
        customView.playPauseButton(isSelected: true)
        player.play()
    }
    
    private func setHideOverlayTimer() {
        hideOverlayTimer?.invalidate()
        hideOverlayTimer = Timer.scheduledTimer(withTimeInterval: Constants.hideOverlayAfterSeconds, repeats: false) { [weak self] _ in
            guard self?.customView.isOverlaysHidden == false,
                  self?.player.timeControlStatus == .playing else {
                return
            }
            self?.customView.hideOverlay()
        }
    }
}

// MARK: - Observers And Subscriptions methods

private extension VideoPlayerController {
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self,
                  let currentItem = player.currentItem,
                  currentItem.status == .readyToPlay else {
                return
            }
            let floatTime = Float(time.seconds)
            customView.setPlaybackSlider(value: floatTime)
            configureLeftRightTime(time: floatTime)
        }
    }
    
    func playerItemSubscriptions(playerItem: AVPlayerItem) {
        playerItem.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                    case .readyToPlay:
                        let duration = Float(playerItem.duration.seconds)
                        customView.setPlaybackSlider(duration: duration)
                        setupInfoCenter(duration: duration)
                        playVideo()
                    case .failed:
                        print("STATUS = failed")
                        print(playerItem.errorLog() ?? "")
                        print(playerItem.error ?? "")
                    default:
                        break
                }
            }
            .store(in: &subscriptions)
        
        playerItem.publisher(for: \.isPlaybackLikelyToKeepUp)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPlaybackLikelyToKeepUp in
                if isPlaybackLikelyToKeepUp == false {
                    self?.customView.showActivityIndicator()
                } else {
                    self?.customView.hideActivityIndicator()
                }
            }
            .store(in: &subscriptions)
    }
    
    func playerSubscriptions() {
        player.publisher(for: \.timeControlStatus)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeControlStatus in
                guard let self else { return }
                let currentTime = player.currentTime().seconds
                switch timeControlStatus {
                    case .playing:
                        if customView.isOverlaysHidden == false {
                            setHideOverlayTimer()
                        }
                        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
                    case .waitingToPlayAtSpecifiedRate, .paused:
                        hideOverlayTimer?.invalidate()
                        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
                    @unknown default:
                        return
                }
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
                nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            }
            .store(in: &subscriptions)
    }
}

// MARK: - VideoPlayerModelDelegate

extension VideoPlayerController: VideoPlayerModelDelegate {
    func configurePlayerItem(url: URL) {
        subscriptions.removeAll()
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(
            asset: asset,
            automaticallyLoadedAssetKeys: [.tracks, .duration, .commonMetadata]
        )
        player.replaceCurrentItem(with: playerItem)
        
        playerSubscriptions()
        playerItemSubscriptions(playerItem: playerItem)
    }
}

// MARK: - VideoPlayerViewDelegate

extension VideoPlayerController: VideoPlayerViewDelegate {
    func statusBarAppearanceUpdate(isHidden: Bool) {
        isStatusBarHidden = isHidden
    }
    
    // MARK: TopView
    func closeButtonDidTapped() {
        willDismiss()
        dismiss(animated: true)
    }
    
    func pipButtonDidTapped() {
        pipController?.startPictureInPicture()
    }
    
    func settingsButtonDidTapped() {
        print(#function)
    }
    
    // MARK: MiddleView
    func backwardButtonDidTapped() {
        guard let duration = player.currentItem?.duration else { return }
        let targetTime = max(.zero, player.currentTime() - CMTime(seconds: 10, preferredTimescale: duration.timescale))
        configurePlayerTime(time: Float(targetTime.seconds))
        player.seek(to: targetTime)
    }
    
    func playPauseButtonDidTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            player.play()
        } else {
            hideOverlayTimer?.invalidate()
            player.pause()
        }
    }
    
    func forwardButtonDidTapped() {
        guard let duration = player.currentItem?.duration else { return }
        let targetTime = min(duration, player.currentTime() + CMTime(seconds: 10, preferredTimescale: duration.timescale))
        configurePlayerTime(time: Float(targetTime.seconds))
        player.seek(to: targetTime)
    }
    
    // MARK: BottomView
    @objc func playbackSliderDidChanged(_ slider: UISlider, event: UIEvent) {
        configurePlayerTime(time: slider.value)
        
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
        let currentPlaylistNumber = model.getCurrentPlaylistNumber()
        let completionBlock: (Int) -> Void = { [weak self] newPlaylistNumber in
            guard let self else { return }
            self.model.replaceCurrentPlaylist(newPlaylistNumber: newPlaylistNumber)
            self.customView.setTitle(self.model.getTitle())
            self.customView.setSubtitle(self.model.getSubtitle())
        }
        navigator?.show(.series(data: data, currentPlaylistNumber: currentPlaylistNumber, completionBlock: completionBlock, presentatingController: self))
    }
}
