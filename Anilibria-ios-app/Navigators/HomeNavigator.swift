//
//  HomeNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol HomeFlow: AnyObject {
    /// use weak !
    var navigator: HomeNavigator? { get set }
}

final class HomeNavigator {
    private let navigationController: UINavigationController
    
    init() {
        let rootViewController = HomeController()
        
        navigationController = HomeNavigator.createNavigationController(for: rootViewController)
        
        rootViewController.navigator = self
    }
        
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Home.title
        let image = UIImage(systemName: Strings.TabBarControllers.Home.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title, 
                                                image: image,
                                                tag: TabBarItemTags.home.rawValue)
        rootViewController.navigationItem.title = Strings.ScreenTitles.home
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Configure navigationBar
        navigationController.navigationBar.standardAppearance.configureWithOpaqueBackground()
        navigationController.navigationBar.standardAppearance.shadowColor = .clear
        navigationController.navigationBar.tintColor = .systemRed
        
        // Common/UINavigationControllerExtension file
        navigationController.interactivePopGestureRecognizer?.delegate = navigationController
        
        return navigationController
    }
}

// MARK: - BasicNavigator

extension HomeNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension HomeNavigator: Navigator {
    enum Destinition {
        case schedule
        case anime(data: TitleAPIModel)
    }
    
    func show(_ destination: Destinition) {
        let viewController = makeViewController(destination)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeViewController(_ destination: Destinition) -> UIViewController {
        let viewController: UIViewController
        switch destination {
            case .schedule:
                let scheduleController = ScheduleController()
                scheduleController.title = Strings.ScreenTitles.schedule
                scheduleController.navigator = self
                viewController = scheduleController
            case .anime(let rawData):
                let animeController = AnimeController(rawData: rawData)
                animeController.navigator = AnimeNavigator(navigationController: navigationController)
                viewController = animeController
        }
        return viewController
    }
}
