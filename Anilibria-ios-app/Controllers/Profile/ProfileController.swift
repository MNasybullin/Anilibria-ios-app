//
//  ProfileController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit
import FDFullscreenPopGesture
import SafariServices

final class ProfileController: UIViewController, ProfileFlow, HasCustomView {
    typealias CustomView = ProfileView
    typealias DonateLocalization = Strings.ProfileModule.Donate
    
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
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
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
    
    func showDonate(anilibriaURL: URL, developerURL: URL) {
        let alertController = UIAlertController(title: DonateLocalization.alertTitle, message: nil, preferredStyle: .actionSheet)
        
        let anilibria = UIAlertAction(title: DonateLocalization.anilibria, style: .default) { [weak self] _ in
            self?.showSite(url: anilibriaURL)
        }
        let developer = UIAlertAction(title: DonateLocalization.developer, style: .default) { [weak self] _ in
            self?.showSite(url: developerURL)
        }
        
        alertController.addAction(anilibria)
        alertController.addAction(developer)
        alertController.addAction(UIAlertAction(title: DonateLocalization.cancel, style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}
