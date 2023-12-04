//
//  VideoPlayerView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.11.2023.
//

import UIKit
import AVKit

protocol VideoPlayerViewDelegate: AnyObject, TopOverlayViewDelegate, MiddleOverlayViewDelegate, BottomOverlayViewDelegate, AVRoutePickerViewDelegate {
    func statusBarAppearanceUpdate(isHidden: Bool)
    func skipButtonDidTapped()
}

final class VideoPlayerView: UIView {
    private enum Constants {
        static let backgroundColor = UIColor.black.withAlphaComponent(0.65)
    }
    
    enum Orientation {
        case portrait, landscape
    }
    
    let playerView = PlayerView()
    private let backgroundView = UIView()
    private let topView = TopOverlayView()
    private let middleView = MiddleOverlayView()
    private let bottomView = BottomOverlayView()
    private lazy var skipButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemRed
        config.title = Strings.VideoPlayerView.skipButton

        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.skipButtonDidTapped()
        }, for: .touchUpInside)
        
        button.isHidden = true
        button.alpha = 0
        return button
    }()
    
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
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension VideoPlayerView {
    func configureView() {
        backgroundColor = .black
        backgroundView.backgroundColor = Constants.backgroundColor
        
        topView.isHidden = false
        middleView.isHidden = true
        bottomView.isHidden = true
        
        showActivityIndicator()
    }
    
    func configureLayout() {
        [playerView, backgroundView, topView, middleView, bottomView, activityIndicator, skipButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // MARK: Show Constraints
        showConstraints = [
            topView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            bottomView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        // MARK: Hide Constraints
        hideConstraints = [
            topView.bottomAnchor.constraint(equalTo: topAnchor),
            bottomView.topAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        // MARK: Common constraints
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            middleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            skipButton.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -24)
        ])
        
        // MARK: Landscape Constraints
        landscapeConstraints = [
            topView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            skipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
        
        // MARK: Portrait Constraints
        portraitConstraints = [
            topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
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
            
            backgroundView.backgroundColor = Constants.backgroundColor
            
            NSLayoutConstraint.deactivate(hideConstraints)
            NSLayoutConstraint.activate(showConstraints)
            layoutIfNeeded()
            delegate?.statusBarAppearanceUpdate(isHidden: isOverlaysHidden)
        }
    }
    
    func hideOverlay() {
        isOverlaysHidden = true
        UIView.animate(withDuration: 0.35) { [self] in
            backgroundView.backgroundColor = UIColor.clear
            
            [topView, middleView, bottomView].forEach {
                $0.alpha = 0
            }
            
            NSLayoutConstraint.deactivate(showConstraints)
            NSLayoutConstraint.activate(hideConstraints)
            layoutIfNeeded()
            delegate?.statusBarAppearanceUpdate(isHidden: isOverlaysHidden)
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
    
    func skipButton(isHidden: Bool) {
        guard skipButton.isHidden != isHidden else { return }
        if isHidden {
            UIView.animate(withDuration: 0.35) { [self] in
                skipButton.alpha = isHidden ? 0 : 1
            } completion: { [self] _ in
                skipButton.isHidden = isHidden
            }
        } else {
            skipButton.isHidden = isHidden
            UIView.animate(withDuration: 0.35) { [self] in
                skipButton.alpha = isHidden ? 0 : 1
            }
        }
    }
}
