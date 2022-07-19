//
//  HomePresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var router: HomeRouterProtocol! { get set }
    var interactor: HomeInteractorProtocol! { get set }
    var view: HomeViewProtocol! { get set }
}

final class HomePresenter: HomePresenterProtocol {
    var router: HomeRouterProtocol!
    
    var interactor: HomeInteractorProtocol!
    
    unowned var view: HomeViewProtocol!
    
}
