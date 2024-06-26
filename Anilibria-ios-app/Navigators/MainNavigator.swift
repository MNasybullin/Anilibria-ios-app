//
//  MainNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol BasicNavigator {
    func initialViewController() -> UIViewController
}

protocol Navigator {
    associatedtype Destination
    
    func show(_ destination: Destination)
}

final class MainNavigator {
    static let shared = MainNavigator()
    
    let rootViewController: RootViewController
    private var tabBarNavigators: [BasicNavigator]
    
    private init() {
        tabBarNavigators = [
            HomeNavigator(),
            SearchNavigator(),
            FavoritesNavigator(),
            ProfileNavigator()
        ]
        
        let controllers = tabBarNavigators.map { $0.initialViewController() }
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = controllers
        
        rootViewController = RootViewController(tabBarController: tabBarController)
    }
}
