//
//  ProfileView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class ProfileView: UIView {
    private let userView: UserView
    
    init(userView: UserView) {
        self.userView = userView
        
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension ProfileView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupLayout() {
        addSubview(userView)
        
        userView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userView.topAnchor.constraint(equalTo: topAnchor),
            userView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33)
        ])
    }
}
