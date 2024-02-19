//
//  AboutAppController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.02.2024.
//

import UIKit

final class AboutAppController: UIViewController, HasCustomView, ProfileFlow {
    typealias CustomView = AboutAppView
    weak var navigator: ProfileNavigator?
    
    private var contentController: AboutAppContentController!
    
    override func loadView() {
        view = AboutAppView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
}

// MARK: - Private methods

private extension AboutAppController {
    func setupContentController() {
        contentController = AboutAppContentController(customView: customView)
        contentController.delegate = self
    }
}

// MARK: - AboutAppContentControllerDelegate

extension AboutAppController: AboutAppContentControllerDelegate {
    func githubItemDidSelected(url: URL) {
        UIApplication.shared.open(url)
    }
}
