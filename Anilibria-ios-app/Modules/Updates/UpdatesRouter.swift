//
//  UpdatesRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation
import UIKit

protocol UpdatesRouterProtocol: AnyObject {
    typealias EntryPoint = UpdatesViewProtocol & UIViewController
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    
    static func start(withNavigationController navigationController: UINavigationController, withData data: [GetTitleModel]?) -> UpdatesRouterProtocol
}

final class UpdatesRouter: UpdatesRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start(withNavigationController navigationController: UINavigationController, withData data: [GetTitleModel]?) -> UpdatesRouterProtocol {
        let router = UpdatesRouter()
        
        let view = UpdatesViewController()
        view.title = Strings.ScreenTitles.updates
        let interactor = UpdatesInteractor()
        interactor.titleModel = data
        let presenter = UpdatesPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view
        
        router.navigationController = navigationController
        return router
    }
}
