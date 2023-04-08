//
//  SeriesPresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import Foundation

protocol SeriesPresenterProtocol: AnyObject {
    var view: SeriesViewProtocol! { get set }
    var interactor: SeriesInteractorProtocol! { get set }
    var router: SeriesRouterProtocol! { get set }
    
    func getData() -> AnimeModel
    func getImage(forIndexPath indexPath: IndexPath)
}

final class SeriesPresenter: SeriesPresenterProtocol {
    unowned var view: SeriesViewProtocol!
    var interactor: SeriesInteractorProtocol!
    var router: SeriesRouterProtocol!

    func getData() -> AnimeModel {
        return interactor.getData()
    }
    
    func getImage(forIndexPath indexPath: IndexPath) {
        Task {
            do {
                guard let image = try await interactor.requestImage(forIndex: indexPath.row) else {
                    return
                }
                view.update(image, for: indexPath)
            } catch {
                ErrorProcessing.shared.handle(error: error) { [weak self] message in
                    if message != MyInternalError.failedToFetchURLFromData.description {
                        self?.view.update(nil, for: indexPath)
                    }
                    print(message)
                }
            }
        }
    }
}
