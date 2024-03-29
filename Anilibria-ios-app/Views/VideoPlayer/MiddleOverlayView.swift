//
//  MiddleOverlayView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.11.2023.
//

import UIKit

protocol MiddleOverlayViewDelegate: AnyObject {
    func backwardButtonDidTapped()
    func playPauseButtonDidTapped(_ button: UIButton)
    func forwardButtonDidTapped()
}

final class MiddleOverlayView: UIView {
    weak var delegate: MiddleOverlayViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 70
        stack.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private lazy var mainImageSize = CGSize(width: 48, height: 48)
    private lazy var secondImageSize = CGSize(width: 32, height: 32)
    
    private lazy var backwardButton: UIButton = {
        let button = ResizeInsidePointButton()
        button.insetBy = (dx: -20, dy: -20)
        button.tintColor = .white
        let image = UIImage(systemName: "goforward.10")?
            .resized(to: secondImageSize)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.backwardButtonDidTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var playImage = UIImage(systemName: "play.fill")?.resized(to: mainImageSize)?.withRenderingMode(.alwaysTemplate)
    private lazy var pauseImage = UIImage(systemName: "pause.fill")?.resized(to: mainImageSize)?.withRenderingMode(.alwaysTemplate)
    
    private lazy var playPauseButton: UIButton = {
        let button = ResizeInsidePointButton()
        button.insetBy = (dx: -20, dy: -20)
        button.tintColor = .white
        button.setImage(playImage, for: .normal)
        button.setImage(pauseImage, for: .selected)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.playPauseButtonDidTapped(button)
        }, for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = ResizeInsidePointButton()
        button.insetBy = (dx: -20, dy: -20)
        button.tintColor = .white
        let image = UIImage(systemName: "goforward.10")?
            .resized(to: secondImageSize)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.forwardButtonDidTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension MiddleOverlayView {
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureLayout() {
        addSubview(stackView)
        
        [backwardButton, playPauseButton, forwardButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Internal methods

extension MiddleOverlayView {
    func showPlayPauseButton() {
        playPauseButton.alpha = 1
    }
    
    func hidePlayPauseButton() {
        playPauseButton.alpha = 0
    }
    
    func playPauseButton(isSelected: Bool) {
        playPauseButton.isSelected = isSelected
    }
}
