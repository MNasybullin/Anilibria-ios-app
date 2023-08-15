//
//  TabBarInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.07.2022.
//

import Foundation

protocol TabBarInteractorProtocol: AnyObject {
    var presenter: TabBarPresenterProtocol! { get set }
}

final class TabBarInteractor: TabBarInteractorProtocol {
    weak var presenter: TabBarPresenterProtocol!
    
}
