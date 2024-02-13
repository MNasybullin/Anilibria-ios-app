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
        
        setupNavBar()
        setupContentController()
    }
}

// MARK: - Private methods

private extension ProfileController {
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
    }
    
    func showAppItem(type: ProfileContentController.AppItem) {
        switch type {
            case .settings:
                break
            case .aboutApp:
                break
        }
    }
}
