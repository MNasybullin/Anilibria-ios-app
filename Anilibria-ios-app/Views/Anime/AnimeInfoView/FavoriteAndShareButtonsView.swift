//
//  FavoriteAndShareButtonsView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.04.2023.
//

import UIKit

protocol FavoriteAndShareButtonsViewDelegate: AnyObject {
    func favoriteButtonClicked()
    func shareButtonClicked()
}

final class FavoriteAndShareButtonsView: UIView {
    weak var delegate: FavoriteAndShareButtonsViewDelegate?
    
    let imagePadding: CGFloat = 5
    
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
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var favoriteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .mini
        config.baseForegroundColor = .secondaryLabel
        
        config.image = UIImage(systemName: "star")
        config.imagePadding = imagePadding
        config.imagePlacement = .top
        
        config.title = "Избранное"
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.favoriteButtonClicked()
        }, for: .touchUpInside)
        
        return button
    }()
    
    lazy var shareButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .small
        config.baseForegroundColor = .secondaryLabel
        
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.imagePadding = imagePadding
        config.imagePlacement = .top
        
        config.title = "Поделиться"
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.shareButtonClicked()
        }, for: .touchUpInside)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(vStack)
        
        vStack.addArrangedSubview(hStack)
        
        hStack.addArrangedSubview(favoriteButton)
        hStack.addArrangedSubview(shareButton)
        
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
struct FavoriteAndShareButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            FavoriteAndShareButtonsView()
        }
        .frame(height: 80)
    }
}

#endif
