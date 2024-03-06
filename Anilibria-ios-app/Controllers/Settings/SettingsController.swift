//
//  SettingsController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsController: UIViewController, HasCustomView, ProfileFlow {
    typealias CustomView = SettingsView
    weak var navigator: ProfileNavigator?
    
    private var contentController: SettingsContentController!
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
}

// MARK: - Private methods

private extension SettingsController {
    func setupContentController() {
        contentController = SettingsContentController(customView: customView)
    }
}
