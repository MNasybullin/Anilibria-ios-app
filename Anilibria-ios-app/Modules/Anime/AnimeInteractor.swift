//
//  AnimeInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import Foundation

protocol AnimeInteractorProtocol: AnyObject {
	var presenter: AnimePresenterProtocol! { get set }
}

final class AnimeInteractor: AnimeInteractorProtocol {
    unowned var presenter: AnimePresenterProtocol!

}
