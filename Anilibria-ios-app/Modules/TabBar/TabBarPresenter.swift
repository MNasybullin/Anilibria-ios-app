//
//  TabBarPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.07.2022.
//

import Foundation

protocol TabBarPresenterProtocol: AnyObject {
    var router: TabBarRouterProtocol! { get set }
    var interactor: TabBarInteractorProtocol! { get set }
    var view: TabBarViewProtocol! { get set }
}

final class TabBarPresenter: TabBarPresenterProtocol {
    var router: TabBarRouterProtocol!
    
    var interactor: TabBarInteractorProtocol!
    
    unowned var view: TabBarViewProtocol!
    
}
