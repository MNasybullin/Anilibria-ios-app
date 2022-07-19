//
//  HomeInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
}

class HomeInteractor: HomeInteractorProtocol {
    unowned var presenter: HomePresenterProtocol!
    
}
