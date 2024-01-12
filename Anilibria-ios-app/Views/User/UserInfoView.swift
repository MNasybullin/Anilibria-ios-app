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
        static let cornerRadius: CGFloat = 25
        static let userNameLabelFontSize: CGFloat = 26
        static let imagePadding: CGFloat = 8
    }
    
    private lazy var logoutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .mini
        config.baseForegroundColor = .systemRed
        config.title = Strings.UserInfoView.logoutButton
        config.imagePadding = Constants.imagePadding

        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.logoutButtonDidTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.userNameLabelFontSize, weight: .regular)
        label.textColor = .label
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
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Constants.cornerRadius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setupLayout() {
        [logoutButton, imageView, userNameLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Internal methods

extension UserInfoView {
    func set(image: UIImage?) {
        imageView.image = image
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    func set(userName: String) {
        userNameLabel.text = userName
    }
    
    func logoutButton(isEnabled: Bool) {
        logoutButton.isEnabled = isEnabled
        logoutButton.configuration?.showsActivityIndicator = !isEnabled
    }
}
