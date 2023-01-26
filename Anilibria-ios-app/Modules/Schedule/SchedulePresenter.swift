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
    func getImage(for indexPath: IndexPath)
}

final class SchedulePresenter: SchedulePresenterProtocol {
    var router: ScheduleRouterProtocol!
    var interactor: ScheduleInteractorProtocol!
    unowned var view: ScheduleViewProtocol!
    
    func getScheduleData() {
        Task {
            do {
                let data = try await interactor.requestScheduleData()
                view.update(data: data)
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.error, message: message)
            }
        }
    }
    
    func getImage(for indexPath: IndexPath) {
        Task {
            do {
                guard let data = try await interactor.requestImageFromData(forSection: indexPath.section, forIndex: indexPath.row) else {
                    return
                }
                view.update(itemData: data, for: indexPath)
            } catch {
                let message = ErrorProcessing.shared.getMessageFrom(error: error)
                view.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
            }
        }
    }
}
