//
//  VideoPlayerOverlayView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.11.2023.
//

import UIKit

protocol VideoPlayerOverlayViewDelegate: AnyObject {
    func didTapGesture()
}

final class VideoPlayerOverlayView: UIView {
    enum Orientation {
        case portrait, landscape
    }
    
    private lazy var topView = TopOverlayView()
    private lazy var middleView = MiddleOverlayView()
    private lazy var bottomView = BottomOverlayView()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemRed
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var showConstraints: [NSLayoutConstraint]!
    private var hideConstraints: [NSLayoutConstraint]!
    
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
        backgroundColor = .black.withAlphaComponent(0.45)
        
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
            topView.topAnchor.constraint(equalTo: topAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        hideConstraints = [
            topView.bottomAnchor.constraint(equalTo: topAnchor),
            bottomView.topAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        // Common constraints
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            middleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
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
        topView.enableButtons()
        UIView.animate(withDuration: 0.35) { [self] in
            [topView, middleView, bottomView].forEach {
                $0.isHidden = false
                $0.alpha = 1
            }
            
            backgroundColor = .black.withAlphaComponent(0.45)
            
            NSLayoutConstraint.deactivate(hideConstraints)
            NSLayoutConstraint.activate(showConstraints)
            layoutIfNeeded()
        }
    }
    
    func hideOverlay() {
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
}
