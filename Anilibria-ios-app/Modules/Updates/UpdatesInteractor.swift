//
//  UpdatesInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation

protocol UpdatesInteractorProtocol: AnyObject {
    var presenter: UpdatesPresenterProtocol! { get set }
}

final class UpdatesInteractor: UpdatesInteractorProtocol {
    unowned var presenter: UpdatesPresenterProtocol!
    
}
