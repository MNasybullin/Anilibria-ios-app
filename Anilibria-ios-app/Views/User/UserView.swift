//
//  UserView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 28.11.2023.
//

import UIKit

final class UserView: UIView {
    let signInView = SignInView()
    let userInfoView = UserInfoView()
    
    private var signInViewTopAnchor: NSLayoutConstraint!
    private var signInViewBottomAnchor: NSLayoutConstraint!
    
    private lazy var currentWindow: UIWindow? = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window
    }()
    
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

private extension UserView {
    func setupView() {
        backgroundColor = .systemGroupedBackground
    }
    
    func setupLayout() {
        [userInfoView, signInView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        signInView.layer.zPosition = 1
        
        signInViewTopAnchor = signInView.topAnchor.constraint(equalTo: topAnchor)
        signInViewBottomAnchor = signInView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: currentWindow?.safeAreaInsets.top ?? 16, leading: 16, bottom: 16, trailing: 16)
        
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: topAnchor),
            userInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userInfoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            signInViewTopAnchor,
            signInView.leadingAnchor.constraint(equalTo: leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: trailingAnchor),
            signInViewBottomAnchor
        ])
    }
}

// MARK: - Internal methods

extension UserView {
    func showSignInView() {
        guard signInView.isHidden == true else {
            return
        }
        signInView.clearTextFields()
        signInView.isHidden = false
        UIView.animate(withDuration: 1) {
            let height = self.signInView.bounds.height
            self.signInViewTopAnchor.constant += height
            self.signInViewBottomAnchor.constant += height
            self.layoutIfNeeded()
        }
    }
    
    func hideSignInView(animated: Bool) {
        guard signInView.isHidden == false else {
            return
        }
        let duration: Double = animated == true ? 1 : 0
        UIView.animate(withDuration: duration) {
            let height = self.signInView.bounds.height
            self.signInViewTopAnchor.constant -= height
            self.signInViewBottomAnchor.constant -= height
            self.layoutIfNeeded()
        } completion: { _ in
            self.signInView.isHidden = true
        }
    }
}
