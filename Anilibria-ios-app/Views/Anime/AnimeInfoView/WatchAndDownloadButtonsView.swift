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
    weak var delegate: WatchAndDownloadButtonsViewDelegate?
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    lazy var watchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemRed
        
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 10
        config.imagePlacement = .leading
        
        config.title = Strings.AnimeView.watchButton
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.watchButtonClicked()
        }, for: .touchUpInside)
        
        return button
    }()
    
    lazy var downloadButton: UIButton = {
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

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct WatchAndDownloadButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            WatchAndDownloadButtonsView()
        }
        .frame(height: 80)
    }
}

#endif
