//
//  ProfileViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class ProfileController: UIViewController, ProfileFlow {
    weak var navigator: ProfileNavigator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
