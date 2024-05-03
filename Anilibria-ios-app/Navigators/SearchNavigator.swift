//
//  SearchNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol SearchFlow: AnyObject {
    /// use weak !
    var navigator: SearchNavigator? { get set }
}

final class SearchNavigator {
    private let navigationController: UINavigationController
    private var subNavigators: [BasicNavigator] = []
    
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
    enum Destination {
        case anime(data: TitleAPIModel, image: UIImage?)
    }
    
    func show(_ destination: Destination) {
        let viewController = makeViewController(destination)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeViewController(_ destination: Destination) -> UIViewController {
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
