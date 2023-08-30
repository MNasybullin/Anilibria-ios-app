//
//  ProfileRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol: AnyObject {
    typealias EntryPoint = ProfileViewProtocol & UIViewController
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    
    static func start() -> ProfileRouterProtocol
}

final class ProfileRouter: ProfileRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start() -> ProfileRouterProtocol {
        let router = ProfileRouter()
        
        let view = ProfileViewController()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.entry = view
        
        router.navigationController = createNavigationController(for: view)
        return router
    }
    
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Profile.title
        let image = UIImage(systemName: Strings.TabBarControllers.Profile.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: TabBarItemsTag.profile.rawValue)
        rootViewController.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.tintColor = .systemRed
        return navigationController
    }
}
