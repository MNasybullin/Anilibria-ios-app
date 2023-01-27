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
    static func start() -> UpdatesRouterProtocol
}

final class UpdatesRouter: UpdatesRouterProtocol {
    var entry: EntryPoint!
    
    static func start() -> UpdatesRouterProtocol {
        let router = UpdatesRouter()
        
        let view = UpdatesViewController()
        let interactor = UpdatesInteractor()
        let presenter = UpdatesPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.entry = view
        
        return router
    }
}
