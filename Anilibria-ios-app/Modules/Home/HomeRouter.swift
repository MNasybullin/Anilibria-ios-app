//
//  HomeRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation
import UIKit
 
protocol HomeRouterProtocol: AnyObject {
    typealias EntryPoint = HomeViewProtocol & UIViewController
    
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    
    static func start() -> HomeRouterProtocol
    
    func showScheduleView()
    func showAnimeView(with data: GetTitleModel)
}

final class HomeRouter: HomeRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start() -> HomeRouterProtocol {
        let router = HomeRouter()
        
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
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
        let title = Strings.TabBarControllers.Home.title
        let image = UIImage(systemName: Strings.TabBarControllers.Home.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: TabBarItemsTag.home.rawValue)
        rootViewController.navigationItem.title = Strings.ScreenTitles.home
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.tintColor = .systemRed
        return navigationController
    }
    
}

// MARK: - Show Other Views

extension HomeRouter {
    func showScheduleView() {
        let scheduleView = ScheduleRouter.start(withNavigationController: navigationController)
        navigationController.pushViewController(scheduleView.entry, animated: true)
    }
    
    func showAnimeView(with data: GetTitleModel) {
        let animeView = AnimeRouter.start(withNavigationController: navigationController, withTitleModel: data)
        navigationController.pushViewController(animeView.entry, animated: true)
    }
    
}
