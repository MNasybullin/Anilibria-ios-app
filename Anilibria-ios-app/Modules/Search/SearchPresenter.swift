//
//  SearchPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.01.2023.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol! { get set }
    var interactor: SearchInteractorProtocol! { get set }
    var router: SearchRouterProtocol! { get set }
}

final class SearchPresenter: SearchPresenterProtocol {
    unowned var view: SearchViewProtocol!
    var interactor: SearchInteractorProtocol!
    var router: SearchRouterProtocol!
}
