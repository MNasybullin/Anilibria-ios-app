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
    
    func signInButtonTapped(email: String, password: String)
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol!
    var interactor: ProfileInteractorProtocol!
    var router: ProfileRouterProtocol!

    func signInButtonTapped(email: String, password: String) {
        Task {
            do {
                let user = try await interactor.authorization(email: email, password: password)
                let userInfo = try await interactor.requestProfileInfo()
                guard let data = userInfo.data else {
                    print("error ") // TODO: - error
                    return
                }
                let userImage = try await interactor.requestImage(forURL: data.avatar)
                view.configureUserView(image: userImage, userName: data.login)
            } catch {
                print(error)
            }
        }
    }
}
