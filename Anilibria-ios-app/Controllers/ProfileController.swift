//
//  ProfileController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit
import FDFullscreenPopGesture

final class ProfileController: UIViewController, ProfileFlow, HasCustomView {
    typealias CustomView = ProfileView
    
    weak var navigator: ProfileNavigator?
    
    private let userController = UserController()
    
    // MARK: LifeCycle
    override func loadView() {
        addChild(userController)
        
        let profileView = ProfileView(userView: userController.customView)
        view = profileView
        
        userController.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.fd_prefersNavigationBarHidden = true
    }
}
