//
//  VideoPlayerController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.11.2023.
//

// swiftlint: disable file_length

import AVKit
import Combine
import MediaPlayer
import OSLog

final class VideoPlayerController: UIViewController, VideoPlayerFlow, HasCustomView {
    typealias CustomView = VideoPlayerView
    
    private enum Constants {
        static let hideOverlayAfterSeconds: Double = 3.0
    }
    
    weak var navigator: VideoPlayerNavigator?
    
    private let logger = Logger(subsystem: .videoPlayer, category: .empty)
    private var interactiveTransitionController: VideoPlayerInteractiveTransitionController!
    
    private let audioSession = AVAudioSession.sharedInstance()
    private let player = AVPlayer()
    private var videoOutput: AVPlayerItemVideoOutput!
    private var pipController: VideoPlayerPiPController?
    private var model: VideoPlayerModel!
    private let remoteCommandCenterController = VideoPlayerRemoteCommandCenterController()
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    
    private var subscriptions = Set<AnyCancellable>()
    private var timeObserverToken: Any?
    
    private var nowPlayingInfo = [String: Any]()
    
    private var hideOverlayTimer: Timer?
    private var forwardBackwardTargetSeconds: Double = 0
    
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
    
    private let needDownloadAnimeData: Bool
    private var animeId: Int
    private var numberOfEpisode: Float?
    
    // MARK: LifeCycle
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        model = VideoPlayerModel(
            animeItem: animeItem,
            currentPlaylist: currentPlaylist
        )
        needDownloadAnimeData = false
        self.animeId = animeItem.id
        super.init(nibName: nil, bundle: nil)
        interactiveTransitionController = VideoPlayerInteractiveTransitionController(viewController: self)
    }
    
    init(animeId: Int, numberOfEpisode: Float) {
        needDownloadAnimeData = true
        self.animeId = animeId
        self.numberOfEpisode = numberOfEpisode
        super.init(nibName: nil, bundle: nil)
        interactiveTransitionController = VideoPlayerInteractiveTransitionController(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let videoPlayerView = VideoPlayerView()
        videoPlayerView.playerView.player = player
        videoPlayerView.ambientPlayerView.player = player
        view = videoPlayerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if needDownloadAnimeData {
            setupControllerNoData()
        } else {
            setupController()
        }
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
        try? audioSession.setActive(false)
        nowPlayingInfoCenter.nowPlayingInfo = nil
    }
}

// MARK: - Setup methods

private extension VideoPlayerController {
    func setupControllerNoData() {
        customView.hideOverlay()
        Task(priority: .userInitiated) {
            do {
                let data = try await VideoPlayerModel.requestAnimeData(id: animeId)
                guard let currentPlaylist = data.playlist.firstIndex(where: { $0.episode == numberOfEpisode }) else {
                    throw NSError(domain: Strings.VideoPlayerView.episodeIsNotFound, code: 0)
                }
                model = VideoPlayerModel(
                    animeItem: data,
                    currentPlaylist: currentPlaylist
                )
                setupController()
                customView.showOverlay()
            } catch {
                closePlayerWithAlert(title: Strings.VideoPlayer.error,
                                     message: error.localizedDescription)
            }
        }
    }
    
    func setupController() {
        setupAudioSession()
        setupView()
        setupPiPController()
        addPeriodicTimeObserver()
        model.delegate = self
        model.start()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setupRemoteCommandCenterController()
    }
    
    func setupAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setActive(true)
        } catch {
            logger.fault("\(Logger.logInfo(error: error)) Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    func setupView() {
        customView.delegate = self
        customView.topView.delegate = self
        customView.topView.routePickerViewDelegate = self
        customView.middleView.delegate = self
        customView.bottomView.delegate = self
        
        customView.topView.setTitle(model.getTitle())
        customView.topView.setSubtitle(model.getSubtitle())
        
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
        customView.bottomView.setPlaybackSlider(value: time)
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(time)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    private func configureLeftRightTime(time: Float) {
        let leftTime = stringFromTimeInterval(interval: TimeInterval(time))
        customView.bottomView.setLeftTimeTitle(leftTime)
        
        if let duration = player.currentItem?.duration {
            let interval = duration.seconds - Double(time)
            let rightTime = stringFromTimeInterval(interval: interval)
            customView.bottomView.setRightTimeTitle("-" + rightTime)
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
        customView.middleView.playPauseButton(isSelected: true)
        player.play()
        player.rate = model.currentRate
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
    
    private func checkSkips(time: Double) {
        let skips = model.skips
        let isContains = skips.contains { (start, finish) in
            if time >= start && time < finish {
                return true
            } else {
                return false
            }
        }
        customView.skipButton(isHidden: !isContains)
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
            configurePlayerTime(time: floatTime)
            checkSkips(time: time.seconds)
            
            model.configureWatchingInfo(duration: currentItem.duration.seconds, playbackPosition: time.seconds, image: getCurrentImage())
        }
    }
    
    func getCurrentImage() -> UIImage? {
        guard let currentItem = player.currentItem else { return nil }
        
        let time = currentItem.currentTime()
        guard let buffer = videoOutput.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else { return nil }
        
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        let image = UIImage(cgImage: cgImage)
        
        return image
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
                        customView.bottomView.setPlaybackSlider(duration: duration)
                        setupInfoCenter(duration: duration)
                        playVideo()
                    case .failed:
                        let failedMessage = "\(String(describing: playerItem.errorLog())) \(String(describing: playerItem.error))"
                        logger.fault("\(Logger.logInfo()) \(failedMessage)")
                        
                        closePlayerWithAlert(title: Strings.VideoPlayer.playbackError,
                                             message: failedMessage)
                    default:
                        break
                }
            }
            .store(in: &subscriptions)
        
        playerItem.publisher(for: \.isPlaybackLikelyToKeepUp)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPlaybackLikelyToKeepUp in
                guard let self else { return }
                if isPlaybackLikelyToKeepUp == false {
                    customView.showActivityIndicator()
                } else {
                    customView.hideActivityIndicator()
                }
            }
            .store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                customView.showOverlay()
                customView.middleView.playPauseButton(isSelected: false)
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
                        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = model.currentRate
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
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        
        setupVideoOutput()
        playerSubscriptions()
        playerItemSubscriptions(playerItem: playerItem)
    }
    
    private func setupVideoOutput() {
        let pixelBufferAttributes: [String: Any] = [
            String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: pixelBufferAttributes)
        player.currentItem?.add(videoOutput)
    }
    
    func configurePlayerItem(url: URL, playbackPostition: Double) {
        configurePlayerItem(url: url)
        
        let playbackTime = CMTime(seconds: playbackPostition, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: playbackTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func configurePlayerItemWithCurrentPlaybackTime(url: URL) {
        let currentPlaybackTime = player.currentTime()
        
        configurePlayerItem(url: url)
        
        player.seek(to: currentPlaybackTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func closePlayerWithAlert(title: String, message: String) {
        Alert.showErrorAlert(on: self, title: title, message: message) { [weak self] in
            self?.willDismiss()
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - VideoPlayerViewDelegate

extension VideoPlayerController: VideoPlayerViewDelegate {
    func skipButtonDidTapped() {
        let skips = model.skips
        let time = player.currentTime().seconds
        let filtered = skips.filter { (start, finish) in
            if time >= start && time < finish {
                return true
            } else {
                return false
            }
        }
        guard let (_, finish) = filtered.first else { return }
        guard let duration = player.currentItem?.duration else { return }
        let finishTime = CMTime(seconds: finish, preferredTimescale: duration.timescale)
        let targetTime = min(duration, finishTime)
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero)
        configurePlayerTime(time: Float(targetTime.seconds))
        customView.skipButton(isHidden: true)
    }
    
    func statusBarAppearanceUpdate(isHidden: Bool) {
        isStatusBarHidden = isHidden
    }
}

// MARK: - TopOverlayViewDelegate

extension VideoPlayerController: TopOverlayViewDelegate {
    func closeButtonDidTapped() {
        willDismiss()
        dismiss(animated: true)
    }
    
    func pipButtonDidTapped() {
        pipController?.startPictureInPicture()
    }
    
    func settingsButtonDidTapped() {
        let hls = model.getHLS()
        let currentHLS = model.currentHLS
        let rate = model.currentRate
        guard let currentHLS, let playerRate = PlayerRate(rawValue: rate) else {
            logger.error("\(Logger.logInfo()) Current HLS is nil or playerRate is init failed")
            return
        }
        navigator?.show(.settings(hls: hls, currentHLS: currentHLS, rate: playerRate, presentatingController: self, delegate: self))
    }
}

// MARK: - MiddleOverlayViewDelegate

extension VideoPlayerController: MiddleOverlayViewDelegate {
    func backwardButtonDidTapped() {
        guard let duration = player.currentItem?.duration else { return }
        forwardBackwardTargetSeconds -= 10
        let targetTime = max(.zero, player.currentTime() + CMTime(seconds: forwardBackwardTargetSeconds, preferredTimescale: duration.timescale))
        configurePlayerTime(time: Float(targetTime.seconds))
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] isFinished in
            guard isFinished else { return }
            self?.forwardBackwardTargetSeconds = 0
        }
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
        forwardBackwardTargetSeconds += 10
        let targetTime = min(duration, player.currentTime() + CMTime(seconds: forwardBackwardTargetSeconds, preferredTimescale: duration.timescale))
        configurePlayerTime(time: Float(targetTime.seconds))
        player.seek(to: targetTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] isFinished in
            guard isFinished else { return }
            self?.forwardBackwardTargetSeconds = 0
        }
    }
}

// MARK: - BottomOverlayViewDelegate

extension VideoPlayerController: BottomOverlayViewDelegate {
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
    
    func episodesButtonDidTapped() {
        let data = model.getData()
        let currentPlaylistNumber = model.currentPlaylistNumber
        let completionBlock: (Int) -> Void = { [weak self] newPlaylistNumber in
            guard let self else { return }
            self.model.replaceCurrentPlaylist(newPlaylistNumber: newPlaylistNumber)
            self.customView.topView.setTitle(self.model.getTitle())
            self.customView.topView.setSubtitle(self.model.getSubtitle())
        }
        navigator?.show(.episodes(data: data, currentPlaylistNumber: currentPlaylistNumber, completionBlock: completionBlock, presentatingController: self))
    }
}

// MARK: - AVRoutePickerViewDelegate

extension VideoPlayerController: AVRoutePickerViewDelegate {
}

// MARK: - VideoPlayerSettingsControllerDelegate

extension VideoPlayerController: VideoPlayerSettingsControllerDelegate {
    func setRate(_ rate: Float) {
        player.rate = rate
        model.setCurrentRate(rate)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime().seconds
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func setHLS(_ hls: HLS) {
        model.changeCurrentHLS(hls)
    }
    
    func updateAmbientModeStatus() {
        customView.ambientPlayerView.updateStatus()
    }
}
