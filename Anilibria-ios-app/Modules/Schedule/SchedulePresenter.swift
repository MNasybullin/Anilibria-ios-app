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
    
    func getScheduleData()
    func getImage(forSection section: Int, forIndex index: Int)
}

final class SchedulePresenter: SchedulePresenterProtocol {
    var router: ScheduleRouterProtocol!
    var interactor: ScheduleInteractorProtocol!
    unowned var view: ScheduleViewProtocol!
    
    func getScheduleData() {
        Task {
            do {
                let data = try await interactor.requestScheduleData()
                view.update(dataArray: data)
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.error, message: message)
            }
        }
    }
    
    func getImage(forSection section: Int, forIndex index: Int) {
        Task {
            do {
                guard let data = try await interactor.requestImageFromData(forSection: section, forIndex: index) else {
                    return
                }
                view.update(ListData: data, forSection: section, forIndex: index)
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
            }
        }
    }
}
