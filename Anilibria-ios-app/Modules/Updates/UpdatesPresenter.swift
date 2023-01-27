//
//  UpdatesPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation

protocol UpdatesPresenterProtocol: AnyObject {
    var view: UpdatesViewProtocol! { get set }
    var interactor: UpdatesInteractorProtocol! { get set }
    var router: UpdatesRouterProtocol! { get set }
}

final class UpdatesPresenter: UpdatesPresenterProtocol {
    unowned var view: UpdatesViewProtocol!
    var interactor: UpdatesInteractorProtocol!
    var router: UpdatesRouterProtocol!
    
}
