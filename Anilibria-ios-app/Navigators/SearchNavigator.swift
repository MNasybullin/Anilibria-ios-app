//
//  SearchNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol SearchFlow: AnyObject {
    var navigator: SearchNavigator? { get set }
}

final class SearchNavigator {
    private let navigationController: UINavigationController
    
    init() {
        let rootViewController = SearchController()
        
        navigationController = SearchNavigator.createNavigationController(for: rootViewController)
        
        rootViewController.navigator = self
    }
        
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Search.title
        let image = UIImage(systemName: Strings.TabBarControllers.Search.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title,
                                                image: image,
                                                tag: TabBarItemTags.search.rawValue)
        rootViewController.navigationItem.title = Strings.ScreenTitles.search
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

extension SearchNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension SearchNavigator: Navigator {
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
                animeController.navigator = AnimeNavigator(navigationController: navigationController)
                viewController = animeController
        }
        return viewController
    }
}
