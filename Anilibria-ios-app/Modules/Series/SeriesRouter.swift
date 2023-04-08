//
//  SeriesRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import Foundation
import UIKit

protocol SeriesRouterProtocol: AnyObject {
    typealias EntryPoint = SeriesViewProtocol & UIViewController
    var entry: EntryPoint! { get }
    var navigationController: UINavigationController! { get }
    
    static func start(withNavigationController navigationController: UINavigationController, withData data: AnimeModel) -> SeriesRouterProtocol
}

final class SeriesRouter: SeriesRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start(withNavigationController navigationController: UINavigationController, withData data: AnimeModel) -> SeriesRouterProtocol {
        let router = SeriesRouter()
        
        let view = SeriesViewController()
        view.title = data.ruName
        let interactor = SeriesInteractor(data: data)
        let presenter = SeriesPresenter()
        
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
