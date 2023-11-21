//
//  ProfileView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class ProfileView: UIView {
    private let signInView: SignInView
    private let userInfoView: UserInfoView
    
    private var signInViewTopAnchor: NSLayoutConstraint!
    
    init(signInView: SignInView, userInfoView: UserInfoView) {
        self.signInView = signInView
        self.userInfoView = userInfoView
        
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(userInfoView)
        addSubview(signInView)
        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userInfoView.topAnchor.constraint(equalTo: topAnchor),
            userInfoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33)
        ])
        
        signInView.translatesAutoresizingMaskIntoConstraints = false
        signInViewTopAnchor = signInView.topAnchor.constraint(equalTo: topAnchor)
        NSLayoutConstraint.activate([
            signInView.leadingAnchor.constraint(equalTo: leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: trailingAnchor),
            signInViewTopAnchor,
            signInView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33)
        ])
    }
}

// MARK: - Internal methods

extension ProfileView {
    func hideSignInView(animated: Bool) {
        guard signInView.isHidden == false else {
            return
        }
        let duration: Double = animated == true ? 1 : 0
        UIView.animate(withDuration: duration) {
            self.signInViewTopAnchor.constant -= self.signInView.bounds.height
            self.layoutIfNeeded()
        } completion: { _ in
            self.signInView.isHidden = true
        }
    }
    
    func showSignInView() {
        guard signInView.isHidden == true else {
            return
        }
        self.signInView.isHidden = false
        UIView.animate(withDuration: 1) {
            self.signInViewTopAnchor.constant += self.signInView.bounds.height
            self.layoutIfNeeded()
        }
    }
}