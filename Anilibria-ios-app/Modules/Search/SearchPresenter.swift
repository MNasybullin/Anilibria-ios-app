//
//  SearchPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.01.2023.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol! { get set }
    var interactor: SearchInteractorProtocol! { get set }
    var router: SearchRouterProtocol! { get set }
    
    func getImage(forIndexPath indexPath: IndexPath)
    func getData(after value: Int)
    func getRandomAnimeData()
}

final class SearchPresenter: SearchPresenterProtocol {
    unowned var view: SearchViewProtocol!
    var interactor: SearchInteractorProtocol!
    var router: SearchRouterProtocol!
    
    func getData(after value: Int) {
        Task {
            do {
                let (data, needLoadMoreData) = try await interactor.requestData(after: value)
                if value == 0 {
                    view.update(data: data)
                } else {
                    view.addMore(data: data, needLoadMoreData: needLoadMoreData)
                }
            } catch {
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.error, message: message)
                }
            }
        }
    }
    
    func getImage(forIndexPath indexPath: IndexPath) {
        if NetworkMonitor.shared.isConnected == false {
            return
        }
        Task {
            do {
                guard let image = try await interactor.requestImage(forIndex: indexPath.row) else {
                    return
                }
                view.update(image: image, for: indexPath)
            } catch {
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
                }
            }
        }
    }
    
    func getRandomAnimeData() {
        Task {
            do {
                let data = try await interactor.requestRandomAnimeData()
                view.updateRandomAnimeView(withData: data)
            } catch {
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.error, message: message)
                }
            }
        }
    }
}
