//
//  UserInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class UserInfoView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 25
        static let userNameLabelFontSize: CGFloat = 26
    }
    
    private var imageView = UIImageView()
    private var userNameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureImageView()
        configureUserNameLabel()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension UserInfoView {
    func configureView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Constants.cornerRadius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func configureImageView() {
        imageView.clipsToBounds = true
    }
    
    func configureUserNameLabel() {
        userNameLabel.font = UIFont.systemFont(ofSize: Constants.userNameLabelFontSize, weight: .regular)
        userNameLabel.textColor = .label
        userNameLabel.textAlignment = .center
    }
    
    func configureLayout() {
        addSubview(imageView)
        addSubview(userNameLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            userNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Internal methods

extension UserInfoView {
    func set(image: UIImage) {
        self.imageView.image = image
        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2
    }
    
    func set(userName: String) {
        self.userNameLabel.text = userName
    }
}
