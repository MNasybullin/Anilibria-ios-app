//
//  WatchAndDownloadView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.04.2023.
//

import UIKit

protocol WatchAndDownloadViewDelegate: AnyObject {
    func watchButtonClicked()
    func downloadButtonClicked()
}

final class WatchAndDownloadView: UIView {
    weak var delegate: WatchAndDownloadViewDelegate?
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var buttonsHStack: UIStackView = {
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
        
        config.title = "Смотреть"
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
        config.baseBackgroundColor = .systemGray5
        
        config.image = UIImage(systemName: "arrow.down.to.line")
        config.imagePlacement = .all
        
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.downloadButtonClicked()
        }, for: .touchUpInside)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(vStack)
        
        setupVStack()
        setupButtonsHStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVStack() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        vStack.addArrangedSubview(buttonsHStack)
    }
    
    private func setupButtonsHStack() {
        buttonsHStack.addArrangedSubview(watchButton)
        buttonsHStack.addArrangedSubview(downloadButton)
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct WatchAndDownloadView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            WatchAndDownloadView()
        }
        .frame(height: 80)
    }
}

#endif
