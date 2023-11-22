//
//  VideoPlayerView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.11.2023.
//

import UIKit
import AVKit

protocol VideoPlayerViewDelegate: AnyObject, TopOverlayViewDelegate, MiddleOverlayViewDelegate, BottomOverlayViewDelegate, AVRoutePickerViewDelegate {
    
}

final class VideoPlayerView: UIView {
    private enum Constants {
        static let backgroundColor = UIColor.black.withAlphaComponent(0.65)
    }
    
    enum Orientation {
        case portrait, landscape
    }
    
    private let playerLayer: AVPlayerLayer
    private let backgroundLayer = CALayer()
    private let topView = TopOverlayView()
    private let middleView = MiddleOverlayView()
    private let bottomView = BottomOverlayView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemRed
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var showConstraints: [NSLayoutConstraint]!
    private var hideConstraints: [NSLayoutConstraint]!
    
    private var landscapeConstraints: [NSLayoutConstraint]!
    private var portraitConstraints: [NSLayoutConstraint]!
    
    private (set) var isOverlaysHidden = false
    
    weak var delegate: VideoPlayerViewDelegate? {
        didSet {
            topView.delegate = delegate
            topView.routePickerViewDelegate = delegate
            middleView.delegate = delegate
            bottomView.delegate = delegate
        }
    }
    
    init(playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        backgroundLayer.frame = bounds
    }
}

// MARK: - Private methods

private extension VideoPlayerView {
    func configureView() {
        layer.addSublayer(playerLayer)
        layer.addSublayer(backgroundLayer)
        
        backgroundColor = .black
        backgroundLayer.backgroundColor = Constants.backgroundColor.cgColor
        
        topView.isHidden = false
        middleView.isHidden = true
        bottomView.isHidden = true
        
        showActivityIndicator()
    }
    
    func configureLayout() {
        [topView, middleView, bottomView, activityIndicator].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        showConstraints = [
            topView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        hideConstraints = [
            topView.bottomAnchor.constraint(equalTo: topAnchor),
            bottomView.topAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        // Common constraints
        NSLayoutConstraint.activate([
            middleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        landscapeConstraints = [
            topView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
        
        portraitConstraints = [
            topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ]
        
        NSLayoutConstraint.activate(showConstraints)
        NSLayoutConstraint.activate(portraitConstraints)
    }
}

// MARK: - Inrernal methods

extension VideoPlayerView {
    func updateConstraints(orientation: Orientation) {
        switch orientation {
            case .portrait:
                NSLayoutConstraint.deactivate(landscapeConstraints)
                NSLayoutConstraint.activate(portraitConstraints)
            case .landscape:
                NSLayoutConstraint.deactivate(portraitConstraints)
                NSLayoutConstraint.activate(landscapeConstraints)
        }
        layoutIfNeeded()
        topView.updateConstraints(orientation: orientation)
    }
    
    func showOverlay() {
        isOverlaysHidden = false
        UIView.animate(withDuration: 0.35) { [self] in
            [topView, middleView, bottomView].forEach {
                $0.isHidden = false
                $0.alpha = 1
            }
            
            backgroundLayer.backgroundColor = Constants.backgroundColor.cgColor
            
            NSLayoutConstraint.deactivate(hideConstraints)
            NSLayoutConstraint.activate(showConstraints)
            layoutIfNeeded()
        }
    }
    
    func hideOverlay() {
        isOverlaysHidden = true
        UIView.animate(withDuration: 0.35) { [self] in
            backgroundLayer.backgroundColor = UIColor.clear.cgColor
            
            [topView, middleView, bottomView].forEach {
                $0.alpha = 0
            }
            
            NSLayoutConstraint.deactivate(showConstraints)
            NSLayoutConstraint.activate(hideConstraints)
            layoutIfNeeded()
        } completion: { [self] isAnimationEnded in
            guard isAnimationEnded == true else { return }
            [topView, middleView, bottomView].forEach {
                $0.isHidden = false
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        middleView.hidePlayPauseButton()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        middleView.showPlayPauseButton()
    }
    
    func setTitle(_ text: String) {
        topView.setTitle(text)
    }
    
    func setSubtitle(_ text: String) {
        topView.setSubtitle(text)
    }
    
    func setPlaybackSlider(duration: Float) {
        bottomView.setSlider(duration: duration)
    }
    
    func setPlaybackSlider(value: Float) {
        bottomView.setSlider(value: value)
    }
    
    func setLeftTime(text: String) {
        bottomView.setLeftTimeTitle(text)
    }
    
    func setRightTime(text: String) {
        bottomView.setRightTimeTitle(text)
    }
    
    func setPIPButton(isHidden: Bool) {
        topView.setPIPButton(isHidden: isHidden)
    }
    
    func playPauseButton(isSelected: Bool) {
        middleView.playPauseButton(isSelected: isSelected)
    }
}
