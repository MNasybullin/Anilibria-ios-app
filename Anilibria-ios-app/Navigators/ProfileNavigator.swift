//
//  ProfileNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol ProfileFlow: AnyObject {
    /// use weak !
    var navigator: ProfileNavigator? { get set }
}

final class ProfileNavigator {
    private let navigationController: UINavigationController
    
    init() {
        let rootViewController = ProfileController()
        
        navigationController = ProfileNavigator.createNavigationController(for: rootViewController)
        
        rootViewController.navigator = self
    }
    
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Profile.title
        let image = UIImage(systemName: Strings.TabBarControllers.Profile.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title,
                                                image: image,
                                                tag: TabBarItemTags.profile.rawValue)
        rootViewController.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.tintColor = .systemRed
        return navigationController
    }
}

// MARK: - BasicNavigator

extension ProfileNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension ProfileNavigator: Navigator {
    enum Destinition {
    }
    
    func show(_ destination: Destinition) {
//        let viewController: UIViewController
//        switch destination {
//            case .profile:
//                viewController = ProfileViewController()
//        }
//        navigationController.pushViewController(viewController, animated: true)
//
//        if let navProtocol = viewController as? ProfileFlow {
//            navProtocol.navigator = self
//        }
    }
}
