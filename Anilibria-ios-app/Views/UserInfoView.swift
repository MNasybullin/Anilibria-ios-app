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
        
        setupView()
        setupImageView()
        setupUserNameLabel()
        
        addSubview(imageView)
        addSubview(userNameLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Constants.cornerRadius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private func setupImageView() {
        imageView.clipsToBounds = true
    }
    
    private func setupUserNameLabel() {
        userNameLabel.font = UIFont.systemFont(ofSize: Constants.userNameLabelFontSize, weight: .regular)
        userNameLabel.textColor = .label
        userNameLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
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

extension UserInfoView {
    func set(image: UIImage) {
        self.imageView.image = image
        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2
    }
    
    func set(userName: String) {
        self.userNameLabel.text = userName
    }
}
