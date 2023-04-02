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
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.error, message: message + " (ScheduleView)")
                }
            }
        }
    }
    
    func getImage(for indexPath: IndexPath) {
        if NetworkMonitor.shared.isConnected == false {
            view.update(image: nil, for: indexPath)
        }
        Task {
            do {
                guard let image = try await interactor.requestImage(forSection: indexPath.section, forIndex: indexPath.row) else {
                    return
                }
                view.update(image: image, for: indexPath)
            } catch {
                view.update(image: nil, for: indexPath)
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
                }
            }
        }
    }
}
