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
    
    #warning("test")
    func createNavigationController(for rootViewController: UIViewController,
                                    title: String,
                                    image: UIImage) -> UIViewController
}

final class TabBarRouter: TabBarRouterProtocol {
    var entry: EntryPoint!
    
    static func start() -> TabBarRouterProtocol {
        let router = TabBarRouter()
        
        let view = TabBarViewController()
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
    
    #warning("test")
    func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
//        navigationController.navigationBar.prefersLargeTitles = true
//        rootViewController.navigationItem.title = title
        return navigationController
    }
    
}
