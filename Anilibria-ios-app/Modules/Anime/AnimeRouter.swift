//
//  AnimeRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import Foundation
import UIKit

protocol AnimeRouterProtocol: AnyObject {
    typealias EntryPoint = AnimeViewProtocol & UIViewController
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    
    static func start(withNavigationController navigationController: UINavigationController) -> AnimeRouterProtocol
}

final class AnimeRouter: AnimeRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start(withNavigationController navigationController: UINavigationController) -> AnimeRouterProtocol {
        let router = AnimeRouter()
        
        let view = AnimeViewController()
        view.title = "Anime"
        let interactor = AnimeInteractor()
        let presenter = AnimePresenter()
        
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
