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
    
    static func start(withNavigationController navigationController: UINavigationController, withTitleModel titleModel: GetTitleModel) -> AnimeRouterProtocol
    
    func showSeriesView(with data: AnimeModel)
}

final class AnimeRouter: AnimeRouterProtocol {
    var entry: EntryPoint!
    var navigationController: UINavigationController!
    
    static func start(withNavigationController navigationController: UINavigationController, withTitleModel titleModel: GetTitleModel) -> AnimeRouterProtocol {
        let router = AnimeRouter()
        
        let view = AnimeViewController()
        view.title = "Anime"
        let interactor = AnimeInteractor(data: titleModel)
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

// MARK: - Show Other Views
extension AnimeRouter {
    func showSeriesView(with data: AnimeModel) {
        let seriesView = SeriesRouter.start(withNavigationController: navigationController, withData: data)
        navigationController.pushViewController(seriesView.entry, animated: true)
    }
}
