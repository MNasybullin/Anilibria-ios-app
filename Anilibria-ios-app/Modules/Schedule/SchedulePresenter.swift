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
    func cellClicked(at indexPath: IndexPath)
}

final class SchedulePresenter: SchedulePresenterProtocol {
    var router: ScheduleRouterProtocol!
    var interactor: ScheduleInteractorProtocol!
    weak var view: ScheduleViewProtocol!
    
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
        Task {
            do {
                let image = try await interactor.requestImage(forSection: indexPath.section, forIndex: indexPath.row)
                view.update(image: image, for: indexPath)
            } catch {
                view.update(image: nil, for: indexPath)
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
                }
            }
        }
    }
    
    func cellClicked(at indexPath: IndexPath) {
        let getScheduleModel = interactor.getData()
        guard let data = getScheduleModel?[indexPath.section].list[indexPath.row] else {
            return
        }
        router.showAnimeView(with: data)
    }
}
