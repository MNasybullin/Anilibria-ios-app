//
//  UpdatesPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation

protocol UpdatesPresenterProtocol: AnyObject {
    var view: UpdatesViewProtocol! { get set }
    var interactor: UpdatesInteractorProtocol! { get set }
    var router: UpdatesRouterProtocol! { get set }
    
    func getUpdatesData()
    func getImage(for indexPath: IndexPath)
}

final class UpdatesPresenter: UpdatesPresenterProtocol {
    unowned var view: UpdatesViewProtocol!
    var interactor: UpdatesInteractorProtocol!
    var router: UpdatesRouterProtocol!
    
    func getUpdatesData() {
        Task {
            do {
                let data = try await interactor.requestUpdatesData()
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
