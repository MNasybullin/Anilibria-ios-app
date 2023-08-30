//
//  ProfilePresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol! { get set }
    var interactor: ProfileInteractorProtocol! { get set }
    var router: ProfileRouterProtocol! { get set }
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol!
    var interactor: ProfileInteractorProtocol!
    var router: ProfileRouterProtocol!

}
