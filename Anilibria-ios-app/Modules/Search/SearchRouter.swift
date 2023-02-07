//
//  SearchRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.01.2023.
//

import Foundation
import UIKit

protocol SearchRouterProtocol: AnyObject {
    typealias EntryPoint = SearchViewProtocol & UIViewController
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    static func start() -> SearchRouterProtocol!
}

final class SearchRouter: SearchRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start() -> SearchRouterProtocol! {
        let router = SearchRouter()
        
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        
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
        let title = Strings.TabBarControllers.Search.title
        let image = UIImage(systemName: Strings.TabBarControllers.Search.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        rootViewController.navigationItem.title = title
        return UINavigationController(rootViewController: rootViewController)
    }
    
}