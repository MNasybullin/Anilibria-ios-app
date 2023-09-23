//
//  ProfileViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
	var presenter: ProfilePresenterProtocol! { get set }
}

final class ProfileViewController: UIViewController, ProfileViewProtocol {
	var presenter: ProfilePresenterProtocol!
    
    private var userInfoView: UserInfoView!
    private var signInView: SignInView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        configureNavBar()
        
        configureUserInfoView()
        configureSignInView()
    }
    
    private func configureNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func configureSignInView() {
        signInView = SignInView()
        view.addSubview(signInView)
        
        signInView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInView.topAnchor.constraint(equalTo: view.topAnchor),
            signInView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)
        ])
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoView()
        view.addSubview(userInfoView)
        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoView.topAnchor.constraint(equalTo: view.topAnchor),
            userInfoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33)
        ])
    }
}

extension ProfileViewController: SignInViewDelegate {
    func signInButtonTapped(email: String, password: String) {
        // TODO - 
    }
}
