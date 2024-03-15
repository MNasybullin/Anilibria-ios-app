//
//  UserController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit
import OSLog

final class UserController: UIViewController, HasCustomView {
    typealias CustomView = UserView
    
    private let model = UserModel()
    private let userDefaults = UserDefaults.standard
    
    private var isAuthorizationProgress: Bool = false {
        didSet {
            guard oldValue != isAuthorizationProgress else { return }
            customView.signInView.activityIndicator(animation: isAuthorizationProgress)
        }
    }
    
    override func loadView() {
        let userView = UserView()
        view = userView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        customView.signInView.delegate = self
        customView.userInfoView.delegate = self
        setupFlow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        customView.userInfoView.updateImageCornerRadius()
    }
}

// MARK: - Private methods

private extension UserController {
    func setupFlow() {
        if userDefaults.isUserAuthorized {
            model.getUserInfo()
        }
    }
}

// MARK: - SignInViewDelegate

extension UserController: SignInViewDelegate {
    func signInButtonTapped(email: String, password: String) {
        isAuthorizationProgress = true
        model.authorization(email: email, password: password)
    }
}

// MARK: - UserInfoViewDelegate

extension UserController: UserInfoViewDelegate {
    func logoutButtonDidTapped() {
        customView.userInfoView.logoutButton(isEnabled: false)
        model.logout()
    }
}

// MARK: - UserModelDelegate

extension UserController: UserModelDelegate {
    func authorizationSuccessful(user: UserItem) {
        DispatchQueue.main.async {
            self.isAuthorizationProgress = false
            self.customView.userInfoView.configure(item: user)
            self.customView.hideSignInView(animated: true)
        }
    }
    
    func authorizationFailure(error: Error) {
        DispatchQueue.main.async {
            self.isAuthorizationProgress = false
            let logger = Logger(subsystem: .user, category: .empty)
            logger.error("\(Logger.logInfo(error: error))")
            
            let data = NotificationBannerView.BannerData(title: Strings.UserModule.Error.authorizationFailure,
                                                         detail: error.localizedDescription,
                                                         type: .error)
            NotificationBannerView(data: data).show()
        }
    }
    
    func requestFromCoreDataSuccessful(user: UserItem) {
        DispatchQueue.main.async {
            self.customView.userInfoView.configure(item: user)
            self.customView.hideSignInView(animated: false)
        }
    }
    
    func requestFromCoreDataFailure(error: Error) {
        DispatchQueue.main.async {
            let logger = Logger(subsystem: .user, category: .coreData)
            logger.error("\(Logger.logInfo(error: error))")
        }
    }
    
    func logoutSuccessful() {
        DispatchQueue.main.async {
            self.customView.showSignInView()
            self.customView.userInfoView.logoutButton(isEnabled: true)
        }
    }
    
    func logoutFailure(error: Error) {
        DispatchQueue.main.async {
            self.customView.userInfoView.logoutButton(isEnabled: true)
            let logger = Logger(subsystem: .user, category: .empty)
            logger.error("\(Logger.logInfo(error: error))")
            
            let data = NotificationBannerView.BannerData(title: Strings.UserModule.Error.logoutFailure,
                                                         detail: error.localizedDescription,
                                                         type: .error)
            NotificationBannerView(data: data).show()
        }
    }
}
