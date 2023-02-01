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

protocol ScrollableViewProtocol {
    func scrollToTop()
}

final class TabBarViewController: UITabBarController, TabBarViewProtocol {
    var presenter: TabBarPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController == viewController {
            guard let navigationController = viewController as? UINavigationController else {
                return true
            }
            guard let scrollableViewController = navigationController.viewControllers.first as? ScrollableViewProtocol else {
                return true
            }
            scrollableViewController.scrollToTop()
        }
        return true
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
