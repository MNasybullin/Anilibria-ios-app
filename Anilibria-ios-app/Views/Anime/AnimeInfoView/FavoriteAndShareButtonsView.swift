//
//  FavoriteAndShareButtonsView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.04.2023.
//

import UIKit

protocol FavoriteAndShareButtonsViewDelegate: AnyObject {
    func favoriteButtonClicked(button: UIButton)
    func shareButtonClicked()
}

final class FavoriteAndShareButtonsView: UIView {
    typealias Localization = Strings.AnimeModule.AnimeView
    weak var delegate: FavoriteAndShareButtonsViewDelegate?
    
    private let imagePadding: CGFloat = 5
    
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
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var favoriteButtonImage = UIImage(systemName: "heart")
    private lazy var favoriteButtonSelectedImage = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    
    private lazy var favoriteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .mini
        config.baseForegroundColor = .secondaryLabel
        config.baseBackgroundColor = .clear
        config.imagePadding = imagePadding
        config.imagePlacement = .top
        config.title = Localization.favoriteButton
        
        let button = UIButton(configuration: config)
        button.setImage(favoriteButtonImage, for: .normal)
        button.setImage(favoriteButtonSelectedImage, for: .selected)
        
        button.addAction(UIAction { [weak self] action in
            guard let sender = action.sender as? UIButton else { return }
            self?.delegate?.favoriteButtonClicked(button: sender)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .small
        config.baseForegroundColor = .secondaryLabel
        
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.imagePadding = imagePadding
        config.imagePlacement = .top
        
        config.title = Localization.shareButton
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

// MARK: - Internal methods

extension FavoriteAndShareButtonsView {
    var favoriteButtonIsSelected: Bool {
        get { favoriteButton.isSelected }
        set { favoriteButton.isSelected = newValue }
    }
    
    var favoriteButtonShowActivityIndicator: Bool {
        get { favoriteButton.configuration?.showsActivityIndicator ?? false }
        set {
            favoriteButton.configuration?.showsActivityIndicator = newValue
            favoriteButton.isEnabled = !newValue
            // if selected, the background will not be clear
            if favoriteButtonIsSelected == true && newValue == true {
                favoriteButtonIsSelected = false
            }
        }
    }
    
    func getFavoriteButtonCenterConverted(to view: UIView) -> CGPoint {
        return hStack.convert(favoriteButton.center, to: view)
    }
}
