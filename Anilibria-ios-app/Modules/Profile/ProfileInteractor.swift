//
//  ProfileInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import Foundation

protocol ProfileInteractorProtocol: AnyObject {
	var presenter: ProfilePresenterProtocol! { get set }
}

final class ProfileInteractor: ProfileInteractorProtocol {
    weak var presenter: ProfilePresenterProtocol!

}
