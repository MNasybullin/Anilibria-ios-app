//
//  ProfileViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
	var presenter: ProfilePresenterProtocol! { get set }
    
    func configureUserView(image: UIImage, userName: String)
}

final class ProfileViewController: UIViewController {
	var presenter: ProfilePresenterProtocol!
    
    private var userInfoView: UserInfoView!
    private var signInView: SignInView!
    
    private var signInViewTopAnchor: NSLayoutConstraint!
    
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
        signInView.delegate = self
        view.addSubview(signInView)
        
        signInView.translatesAutoresizingMaskIntoConstraints = false
        signInViewTopAnchor = signInView.topAnchor.constraint(equalTo: view.topAnchor)
        NSLayoutConstraint.activate([
            signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signInViewTopAnchor,
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
    
    private func hideSignInView() {
        UIView.animate(withDuration: 1) {
            self.signInViewTopAnchor.constant -= self.signInView.bounds.height
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.signInView.isHidden = true
        }
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func configureUserView(image: UIImage, userName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userInfoView.set(image: image)
            self?.userInfoView.set(userName: userName)
            self?.hideSignInView()
        }
    }
}

extension ProfileViewController: SignInViewDelegate {
    func signInButtonTapped(email: String, password: String) {
        presenter.signInButtonTapped(email: email, password: password)
    }
}
