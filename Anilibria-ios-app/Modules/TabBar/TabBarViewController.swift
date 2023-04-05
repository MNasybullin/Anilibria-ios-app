//
//  TabBarViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.07.2022.
//

import Foundation
import UIKit

protocol TabBarViewProtocol: AnyObject {
    var presenter: TabBarPresenterProtocol! { get set }
}

final class TabBarViewController: UITabBarController, TabBarViewProtocol {
    var presenter: TabBarPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        tabBar.tintColor = .systemRed
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController == viewController {
            guard let navigationController = viewController as? UINavigationController else {
                return true
            }
            ifScrollableViewProtocol(in: navigationController)
            ifSearchViewController(in: navigationController)
        }
        return true
    }
    
    private func ifScrollableViewProtocol(in navigationController: UINavigationController) {
        guard let scrollableViewProtocol = navigationController.viewControllers.first as? ScrollableViewProtocol else {
            return
        }
        scrollableViewProtocol.scrollToTop()
    }
    
    private func ifSearchViewController(in navigationController: UINavigationController) {
        guard let searchViewController = navigationController.viewControllers.first as? SearchViewController else {
            return
        }
        searchViewController.searchBar.becomeFirstResponder()
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct TabBarController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            TabBarRouter.start().entry
        }
    }
}

#endif
