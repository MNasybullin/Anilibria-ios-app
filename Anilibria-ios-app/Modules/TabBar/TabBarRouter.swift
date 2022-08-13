//
//  TabBarRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.07.2022.
//

import Foundation
import UIKit

protocol TabBarRouterProtocol: AnyObject {
    typealias EntryPoint = TabBarViewProtocol & UITabBarController
    
    var entry: EntryPoint! { get }
    
    static func start() -> TabBarRouterProtocol
}

final class TabBarRouter: TabBarRouterProtocol {
    var entry: EntryPoint!
    
    static func start() -> TabBarRouterProtocol {
        let router = TabBarRouter()
        
        let view = TabBarViewController()
        view.setViewControllers(
            [
                HomeRouter.start().navigationController
            ],
            animated: true)
        
        let interactor = TabBarInteractor()
        let presenter = TabBarPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view
        
        return router
    }
    
//    private static func createNavigationController(for rootViewController: UIViewController,
//                                                   title: String,
//                                                   image: UIImage?) -> UIViewController {
//        let navigationController = UINavigationController(rootViewController: rootViewController)
//        navigationController.tabBarItem.title = title
//        navigationController.tabBarItem.image = image
//        navigationController.navigationBar.prefersLargeTitles = true
//        rootViewController.navigationItem.title = title
//        return navigationController
//    }
    
//    private static func setupViewControllers() -> [UIViewController]? {
//        return [
//            createNavigationController(for: HomeRouter.start().entry,
//                                       title: Strings.TabBarControllers.Home.title,
//                                       image: UIImage.init(systemName: Strings.TabBarControllers.Home.image)),
//            createNavigationController(for: HomeRouter.start().entry,
//                                       title: Strings.TabBarControllers.Search.title,
//                                       image: UIImage.init(systemName: Strings.TabBarControllers.Search.image)),
//            createNavigationController(for: HomeRouter.start().entry,
//                                       title: Strings.TabBarControllers.Favorites.title,
//                                       image: UIImage.init(systemName: Strings.TabBarControllers.Favorites.image)),
//            createNavigationController(for: HomeRouter.start().entry,
//                                       title: Strings.TabBarControllers.Profile.title,
//                                       image: UIImage.init(systemName: Strings.TabBarControllers.Profile.image))
//        ]
//    }
    
}
