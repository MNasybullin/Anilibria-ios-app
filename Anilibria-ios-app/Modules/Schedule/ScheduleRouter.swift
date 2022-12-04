//
//  ScheduleRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation
import UIKit

protocol ScheduleRouterProtocol: AnyObject {
    typealias EntryPoint = ScheduleViewProtocol & UIViewController
    
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    
    static func start(withNavigationController navigationController: UINavigationController) -> ScheduleRouterProtocol
}

final class ScheduleRouter: ScheduleRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start(withNavigationController navigationController: UINavigationController) -> ScheduleRouterProtocol {
        let router = ScheduleRouter()
        
        let view = ScheduleViewController()
        let interactor = ScheduleInteractor()
        let presenter = SchedulePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.entry = view
        
        router.navigationController = navigationController
        return router
    }
}
