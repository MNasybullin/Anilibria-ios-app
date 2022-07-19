//
//  HomeRouter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation
import UIKit
 
protocol HomeRouterProtocol: AnyObject {
    typealias EntryPoint = HomeViewProtocol & UIViewController // UIVIewController ?
    
    var entry: EntryPoint! { get }
    
    static func start() -> HomeRouterProtocol
}

final class HomeRouter: HomeRouterProtocol {
    var entry: EntryPoint!
    
    static func start() -> HomeRouterProtocol {
        let router = HomeRouter()
        
        let view = HomeView()
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.entry = view
        
        return router
    }
    
}
