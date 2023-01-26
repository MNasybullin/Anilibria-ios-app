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
    func showUpdatesView(with data: [GetTitleModel]?)
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
        
        router.navigationController = createNavigationController(for: view,
                                   title: Strings.TabBarControllers.Home.title,
                                   image: UIImage.init(systemName: Strings.TabBarControllers.Home.image))
        return router
    }
    
    private static func createNavigationController(for rootViewController: UIViewController,
                                                   title: String,
                                                   image: UIImage?) -> UINavigationController {
        rootViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
        rootViewController.navigationItem.title = title
        return UINavigationController(rootViewController: rootViewController)
    }
    
}

// MARK: - Show Other Views

extension HomeRouter {
    func showScheduleView() {
        let scheduleView = ScheduleRouter.start(withNavigationController: navigationController)
        navigationController.pushViewController(scheduleView.entry, animated: true)
    }
    
    func showUpdatesView(with data: [GetTitleModel]?) {
//        let updatesView = updatesRouter.start(withNavigationController: navigationController, data: data)
//        navigationController.pushViewController(updatesView.entry, animated: true)
    }
}
