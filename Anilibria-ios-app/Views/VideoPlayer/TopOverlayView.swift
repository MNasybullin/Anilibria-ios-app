//
//  TopOverlayView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.11.2023.
//

import UIKit
import AVKit

protocol TopOverlayViewDelegate: AnyObject {
    func closeButtonDidTapped()
    func pipButtonDidTapped()
    func settingsButtonDidTapped()
}

final class TopOverlayView: UIView {
    typealias Orientation = VideoPlayerView.Orientation
    
    weak var delegate: TopOverlayViewDelegate?
    
    private enum Constants {
        static let leftRightMiddleStackConstraints: CGFloat = 8
        static let buttonSpacing: CGFloat = 32
        static let top: CGFloat = 24
    }
    
    private lazy var closeButton: UIButton = {
        let button = TopOverlayButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.closeButtonDidTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var pipButton: UIButton = {
        let button = TopOverlayButton(type: .system)
        button.tintColor = .white
        let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
        button.setImage(startImage, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.pipButtonDidTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var middleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var routePickerView: AVRoutePickerView = {
        let routePickerView = AVRoutePickerView()
        routePickerView.backgroundColor = .clear
        routePickerView.tintColor = .white
        routePickerView.activeTintColor = .systemRed
        routePickerView.prioritizesVideoDevices = true
        return routePickerView
    }()
    
    var routePickerViewDelegate: AVRoutePickerViewDelegate? {
        get { routePickerView.delegate }
        set { routePickerView.delegate = newValue }
    }
    
    private lazy var settingsButton: UIButton = {
        let button = TopOverlayButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.settingsButtonDidTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private var landscapeConstraints: [NSLayoutConstraint]!
    private var portraitConstraints: [NSLayoutConstraint]!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension TopOverlayView {
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureLayout() {
        [closeButton, pipButton, middleStack, routePickerView, settingsButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [titleLabel, subtitleLabel].forEach { middleStack.addArrangedSubview($0) }
        
        // Common Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.top),
            pipButton.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: Constants.buttonSpacing),
            pipButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            middleStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            settingsButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            routePickerView.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
            routePickerView.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -Constants.buttonSpacing)
        ])
        
        landscapeConstraints = [
            closeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            
            middleStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.top),
            middleStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleStack.leadingAnchor.constraint(greaterThanOrEqualTo: pipButton.trailingAnchor, constant: Constants.leftRightMiddleStackConstraints),
            middleStack.trailingAnchor.constraint(lessThanOrEqualTo: routePickerView.leadingAnchor, constant: -Constants.leftRightMiddleStackConstraints),
            
            settingsButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
        
        portraitConstraints = [
            closeButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            middleStack.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: Constants.top),
            middleStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            middleStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            settingsButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(portraitConstraints)
    }
}

// MARK: - Inrernal methods

extension TopOverlayView {
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
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    func setSubtitle(_ text: String?) {
        subtitleLabel.text = text
    }
    
    func setPIPButton(isHidden: Bool) {
        pipButton.isHidden = isHidden
    }
}
