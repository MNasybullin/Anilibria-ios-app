//
//  TabBarController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

enum TabBarItemTags: Int {
    case home = 0
    case search = 1
    case profile = 2
}

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemRed
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController == viewController {
            guard let navigationController = viewController as? UINavigationController else {
                return true
            }
            
            switch navigationController.viewControllers.first {
                case let scrollableViewProtocol as HasScrollableView:
                    scrollableViewProtocol.scrollToTop()
                case let searchBarProtocol as HasSearchBar:
                    searchBarProtocol.searchBarBecomeFirstResponder()
                default:
                    break
            }
        }
        return true
    }
}
