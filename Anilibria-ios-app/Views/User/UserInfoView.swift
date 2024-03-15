//
//  UserInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

protocol UserInfoViewDelegate: AnyObject {
    func logoutButtonDidTapped()
}

final class UserInfoView: UIView {
    private enum Constants {
        static let viewCornerRadius: CGFloat = 25
        static let userNameLabelFontSize: CGFloat = 26
        static let emailLabelFontSize: CGFloat = 16
        static let logoutButtonImagePadding: CGFloat = 8
        static let stackSpacing: CGFloat = 8
    }
    
    private lazy var logoutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .mini
        config.baseForegroundColor = .systemRed
        config.title = Strings.UserInfoView.logoutButton
        config.imagePadding = Constants.logoutButtonImagePadding

        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.logoutButtonDidTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constants.stackSpacing
        return stack
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Assets.noAvatar.image
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.userNameLabelFontSize, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.emailLabelFontSize, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    weak var delegate: UserInfoViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension UserInfoView {
    func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = Constants.viewCornerRadius
    }
    
    func setupLayout() {
        [contentStack, logoutButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [imageView, userNameLabel, emailLabel].forEach {
            contentStack.addArrangedSubview($0)
        }
        
        preservesSuperviewLayoutMargins = true
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}

// MARK: - Internal methods

extension UserInfoView {
    func configure(item: UserItem) {
        if let image = item.image {
            imageView.image = image
            updateImageCornerRadius()
        }
        userNameLabel.text = item.login
        emailLabel.text = item.email
    }
    
    func logoutButton(isEnabled: Bool) {
        logoutButton.isEnabled = isEnabled
        logoutButton.configuration?.showsActivityIndicator = !isEnabled
    }
    
    func updateImageCornerRadius() {
        imageView.layer.cornerRadius = imageView.bounds.width / 2.0
    }
}
