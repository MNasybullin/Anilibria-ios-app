//
//  AnimePresenter.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import UIKit

protocol AnimePresenterProtocol: AnyObject {
    var view: AnimeViewProtocol! { get set }
    var interactor: AnimeInteractorProtocol! { get set }
    var router: AnimeRouterProtocol! { get set }
    
    func getData() -> AnimeModel
    func getImage()
    func seriesViewClicked()
}

final class AnimePresenter: AnimePresenterProtocol {
    unowned var view: AnimeViewProtocol!
    var interactor: AnimeInteractorProtocol!
    var router: AnimeRouterProtocol!
    
    func getData() -> AnimeModel {
        let data = interactor.getData()
        if data.image == nil {
            getImage()
        }
        return data
    }
    
    func getImage() {
        if NetworkMonitor.shared.isConnected == false {
            return
        }
        Task {
            do {
                guard let image = try await interactor.requestImage() else {
                    return
                }
                view.update(image: image)
            } catch {
                ErrorProcessing.shared.handle(error: error) { message in
                    print("error: ", message)
                }
            }
        }
    }
    
    func seriesViewClicked() {
        let data = getData()
        router.showSeriesView(with: data)
    }
}
