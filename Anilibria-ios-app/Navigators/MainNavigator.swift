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
    associatedtype Destinition
    
    func show(_ destination: Destinition)
}

final class MainNavigator {
    static let shared = MainNavigator()
    
    let rootViewController: RootViewController
    private var navigators: [BasicNavigator]
    
    private init() {
        navigators = [
            HomeNavigator(),
            SearchNavigator(),
            ProfileNavigator()
        ]
        
        let controllers = navigators.map { $0.initialViewController() }
        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = controllers
        
        rootViewController = RootViewController(tabBarController: tabBarController)
    }
}
