//
//  SchedulePresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation

protocol SchedulePresenterProtocol: AnyObject {
    var router: ScheduleRouterProtocol! { get set }
    var interactor: ScheduleInteractorProtocol! { get set }
    var view: ScheduleViewProtocol! { get set }
}

final class SchedulePresenter: SchedulePresenterProtocol {
    var router: ScheduleRouterProtocol!
    var interactor: ScheduleInteractorProtocol!
    unowned var view: ScheduleViewProtocol!
    
}
