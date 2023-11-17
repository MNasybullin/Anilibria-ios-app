//
//  VideoPlayerOverlayView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.11.2023.
//

import UIKit
import AVKit

protocol VideoPlayerOverlayViewDelegate: AnyObject {
    func didTapGesture()
}

final class VideoPlayerOverlayView: UIView {
    private enum Constants {
        static let backgroundColor = UIColor.black.withAlphaComponent(0.65)
    }
    
    enum Orientation {
        case portrait, landscape
    }
    
    let topView = TopOverlayView()
    let middleView = MiddleOverlayView()
    let bottomView = BottomOverlayView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemRed
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var showConstraints: [NSLayoutConstraint]!
    private var hideConstraints: [NSLayoutConstraint]!
    
    private (set) var isOverlaysHidden = false
    
    weak var delegate: VideoPlayerOverlayViewDelegate?
    
    var topViewDelegate: TopOverlayViewDelegate? {
        get { topView.delegate }
        set { topView.delegate = newValue }
    }
    
    var middleViewDelegate: MiddleOverlayViewDelegate? {
        get { middleView.delegate }
        set { middleView.delegate = newValue }
    }
    
    var bottomViewDelegate: BottomOverlayViewDelegate? {
        get { bottomView.delegate }
        set { bottomView.delegate = newValue }
    }
    
    var routePickerViewDelegate: AVRoutePickerViewDelegate? {
        get { topView.routePickerViewDelegate }
        set { topView.routePickerViewDelegate = newValue }
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        configureTapGR()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension VideoPlayerOverlayView {
    func configureView() {
        backgroundColor = Constants.backgroundColor
        
        topView.isHidden = false
        middleView.isHidden = true
        bottomView.isHidden = true
        showActivityIndicator()
    }
    
    func configureTapGR() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGesture() {
        delegate?.didTapGesture()
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
            topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            middleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        NSLayoutConstraint.activate(showConstraints)
    }
}

// MARK: - Inrernal methods

extension VideoPlayerOverlayView {
    func updateConstraints(orientation: Orientation) {
        topView.updateConstraints(orientation: orientation)
    }
    
    func showOverlay() {
        topView.showPipButton()
        isOverlaysHidden = false
        UIView.animate(withDuration: 0.35) { [self] in
            [topView, middleView, bottomView].forEach {
                $0.isHidden = false
                $0.alpha = 1
            }
            
            backgroundColor = Constants.backgroundColor
            
            NSLayoutConstraint.deactivate(hideConstraints)
            NSLayoutConstraint.activate(showConstraints)
            layoutIfNeeded()
        }
    }
    
    func hideOverlay() {
        isOverlaysHidden = true
        UIView.animate(withDuration: 0.35) { [self] in
            backgroundColor = .clear
            
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
}
