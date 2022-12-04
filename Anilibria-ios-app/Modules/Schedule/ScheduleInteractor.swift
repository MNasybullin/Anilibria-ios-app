//
//  ScheduleInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation

protocol ScheduleInteractorProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
}

final class ScheduleInteractor: ScheduleInteractorProtocol {
    unowned var presenter: SchedulePresenterProtocol!
    
}
