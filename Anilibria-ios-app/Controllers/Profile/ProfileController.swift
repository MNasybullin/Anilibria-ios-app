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
    
    private var contentController: ProfileContentController!
    
    // MARK: LifeCycle
    override func loadView() {
        view = ProfileView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupNavBar()
        setupContentController()
    }
}

// MARK: - Private methods

private extension ProfileController {
    func setupNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func setupNavBar() {
        self.fd_prefersNavigationBarHidden = true
    }
    
    func setupContentController() {
        contentController = ProfileContentController(customView: customView)
        contentController.delegate = self
    }
}

// MARK: - ProfileContentControllerDelegate

extension ProfileController: ProfileContentControllerDelegate {
    func showSite(url: URL) {
        UIApplication.shared.open(url)
    }
    
    func showTeam(data: TeamAPIModel) {
        navigator?.show(.team(rawData: data))
    }
    
    func showAppItem(type: ProfileContentController.AppItem) {
        switch type {
            case .settings:
                navigator?.show(.settings)
            case .aboutApp:
                navigator?.show(.aboutApp)
        }
    }
}
