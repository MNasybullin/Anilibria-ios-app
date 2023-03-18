//
//  AnimePresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import Foundation

protocol AnimePresenterProtocol: AnyObject {
    var view: AnimeViewProtocol! { get set }
    var interactor: AnimeInteractorProtocol! { get set }
    var router: AnimeRouterProtocol! { get set }
}

final class AnimePresenter: AnimePresenterProtocol {
    unowned var view: AnimeViewProtocol!
    var interactor: AnimeInteractorProtocol!
    var router: AnimeRouterProtocol!

}
