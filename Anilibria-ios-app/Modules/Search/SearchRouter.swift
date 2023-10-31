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
    
    func showAnimeView(with data: TitleAPIModel)
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
//        Common/UINavigationControllerExtension file
        router.navigationController.interactivePopGestureRecognizer?.delegate = router.navigationController
        return router
    }
    
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Search.title
        let image = UIImage(systemName: Strings.TabBarControllers.Search.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: TabBarItemTags.search.rawValue)
        rootViewController.navigationItem.title = title
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.tintColor = .systemRed
        return navigationController
    }
}

// MARK: - Show Other Views
extension SearchRouter {
    func showAnimeView(with data: TitleAPIModel) {
//        let animeView = AnimeRouter.start(withNavigationController: navigationController, withTitleModel: data)
//        navigationController.pushViewController(animeView.entry, animated: true)
    }
}
