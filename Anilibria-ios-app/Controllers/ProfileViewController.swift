//
//  ProfileController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class ProfileController: UIViewController, ProfileFlow, HasCustomView {
    typealias CustomView = ProfileView
    
    weak var navigator: ProfileNavigator?
    
    private let signInController = SignInController()
    private let userInfoController = UserInfoController()
    
    // MARK: LifeCycle
    override func loadView() {
        addChild(signInController)
        addChild(userInfoController)
        
        let profileView = ProfileView(signInView: signInController.customView, userInfoView: userInfoController.customView)
        view = profileView
        
        signInController.didMove(toParent: self)
        userInfoController.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInController.delegate = self
        userInfoController.delegate = self
        
        hideKeyboardWhenTappedAround()
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - SignInControllerDelegate

extension ProfileController: SignInControllerDelegate {
    func authorizationIsSuccessful() {
        userInfoController.configureView { [weak self] in
            self?.customView.hideSignInView()
        }
    }
    
    func authorizationIsFailure(error: Error) {
        // TODO
        print(#file, #function, error)
    }
}

// MARK: - UserInfoControllerDelegate

extension ProfileController: UserInfoControllerDelegate {
    func getUserInfoIsFailure(error: Error) {
        // TODO
        print(#file, #function, error)
    }
}
