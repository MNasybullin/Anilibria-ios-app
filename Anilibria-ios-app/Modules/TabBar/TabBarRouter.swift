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
                HomeRouter.start().navigationController,
                SearchRouter.start().navigationController,
                ProfileRouter.start().navigationController
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
        
}
