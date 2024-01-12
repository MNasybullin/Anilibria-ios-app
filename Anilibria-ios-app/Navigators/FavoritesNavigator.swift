//
//  FavoritesNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.01.2024.
//

import UIKit

protocol FavoritesFlow: AnyObject {
    /// use weak !
    var navigator: FavoritesNavigator? { get set }
}

final class FavoritesNavigator {
    private let navigationController: UINavigationController
    private var subNavigators: [BasicNavigator] = []
    
    init() {
        let rootViewController = FavoritesController()
        
        navigationController = FavoritesNavigator.createNavigationController(for: rootViewController)
        
        rootViewController.navigator = self
    }
        
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Favorites.title
        let image = UIImage(systemName: Strings.TabBarControllers.Favorites.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title,
                                                image: image,
                                                tag: TabBarItemTags.favorites.rawValue)
        rootViewController.navigationItem.title = Strings.ScreenTitles.favorites
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

extension FavoritesNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension FavoritesNavigator: Navigator {
    enum Destinition {
        case anime(data: TitleAPIModel, image: UIImage?)
    }
    
    func show(_ destination: Destinition) {
        let viewController = makeViewController(destination)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeViewController(_ destination: Destinition) -> UIViewController {
        let viewController: UIViewController
        switch destination {
            case .anime(let rawData, let image):
                let animeController = AnimeController(rawData: rawData, image: image)
                let animeNavigator = AnimeNavigator(navigationController: navigationController)
                subNavigators.append(animeNavigator)
                animeController.navigator = animeNavigator
                viewController = animeController
        }
        return viewController
    }
}
