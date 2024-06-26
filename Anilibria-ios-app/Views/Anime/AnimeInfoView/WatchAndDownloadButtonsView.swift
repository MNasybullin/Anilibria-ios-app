//
//  WatchAndDownloadButtonsView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.04.2023.
//

import UIKit

protocol WatchAndDownloadButtonsViewDelegate: AnyObject {
    func watchButtonClicked()
    func downloadButtonClicked()
}

final class WatchAndDownloadButtonsView: UIView {
    typealias Localization = Strings.AnimeModule.AnimeView
    weak var delegate: WatchAndDownloadButtonsViewDelegate?
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    private lazy var watchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemRed
        
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 10
        config.imagePlacement = .leading
        
        config.title = Localization.watchButton
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.watchButtonClicked()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var downloadButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .secondaryLabel
        
        config.image = UIImage(systemName: "arrow.down.to.line")
        config.imagePlacement = .all
        
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.downloadButtonClicked()
        }, for: .touchUpInside)
        
        button.isEnabled = false
        button.isHidden = true
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(vStack)
        
        vStack.addArrangedSubview(hStack)
        
        hStack.addArrangedSubview(watchButton)
        hStack.addArrangedSubview(downloadButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Internal methods

extension WatchAndDownloadButtonsView {
    func configureWatchButton(episodeNumber: Float?) {
        if let episodeNumber {
            let episodeInt = Int(exactly: episodeNumber)
            watchButton.configuration?.title = "\(episodeInt?.description ?? episodeNumber.description) серия"
        }
    }
}
