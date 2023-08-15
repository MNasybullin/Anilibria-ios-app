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
    func cellClicked(at indexPath: IndexPath)
}

final class SeriesPresenter: SeriesPresenterProtocol {
    weak var view: SeriesViewProtocol!
    var interactor: SeriesInteractorProtocol!
    var router: SeriesRouterProtocol!

    func getData() -> AnimeModel {
        return interactor.getData()
    }
    
    func getImage(forIndexPath indexPath: IndexPath) {
        Task {
            do {
                let image = try await interactor.requestImage(forIndex: indexPath.row)
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
    
    func cellClicked(at indexPath: IndexPath) {
        Task {
            do {
                let cachingNodes = try await interactor.requestCachingNodes()
                let data = getData()
                guard let hlsQuality = data.playlist[indexPath.row].hls?.fhd,
                      let url = URL(string: "https://" + cachingNodes + hlsQuality) else {
                    print("Ошибка URL или отсутсвует ссылка на видео. file = \(#file), function = \(#function), line = \(#line)")
                    return
                }
                // TODO: Сдлеать выбор качества видео.
                router.showPlayer(url: url)
            } catch {
                ErrorProcessing.shared.handle(error: error) { message in
                    print(message)
                }
            }
        }
    }
}
