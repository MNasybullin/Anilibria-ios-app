//
//  SeriesPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import Foundation

protocol SeriesPresenterProtocol: AnyObject {
    var view: SeriesViewProtocol! { get set }
    var interactor: SeriesInteractorProtocol! { get set }
    var router: SeriesRouterProtocol! { get set }
}

final class SeriesPresenter: SeriesPresenterProtocol {
    unowned var view: SeriesViewProtocol!
    var interactor: SeriesInteractorProtocol!
    var router: SeriesRouterProtocol!

}
