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
    
    func cancellTasks()
    func getImage(forIndexPath indexPath: IndexPath)
    func getSearchResults(searchText: String, after value: Int)
    func getRandomAnimeData()
    func deleteSearchResultsData()
    func cellClicked(at indexPath: IndexPath)
    func randomAnimeViewTapped()
}

final class SearchPresenter: SearchPresenterProtocol {
    unowned var view: SearchViewProtocol!
    var interactor: SearchInteractorProtocol!
    var router: SearchRouterProtocol!
    
    var searchResultsTasks: [Task<(), Never>] = [Task<(), Never>]()
    var imageTasks: [Task<(), Never>] = [Task<(), Never>]()
    
    func cancellTasks() {
        searchResultsTasks.forEach { $0.cancel() }
        searchResultsTasks.removeAll()
        
        imageTasks.forEach { $0.cancel() }
        imageTasks.removeAll()
    }
    
    func getSearchResults(searchText: String, after value: Int) {
        let task = Task {
            do {
                let (data, needLoadMoreData) = try await interactor.searchTitles(searchText: searchText, after: value)
                if Task.isCancelled { return }
                if value == 0 {
                    view.updateSearchResultsTableView(data: data)
                } else {
                    view.addMoreSearchResultsTableView(data: data, needLoadMoreData: needLoadMoreData)
                }
            } catch {
                if Task.isCancelled { return }
                if value != 0 {
                    view.showSearchResultsErrorFooterView(with: error.localizedDescription)
                    return
                }
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.error, message: message)
                }
            }
        }
        searchResultsTasks.append(task)
    }
    
    func deleteSearchResultsData() {
        interactor.deleteSearchResultsData()
    }
    
    func getImage(forIndexPath indexPath: IndexPath) {
        if NetworkMonitor.shared.isConnected == false {
            view.updateSearchResultsTableView(image: nil, for: indexPath)
            return
        }
        let task = Task {
            do {
                guard let image = try await interactor.requestImage(forIndexPath: indexPath) else {
                    return
                }
                if Task.isCancelled { return }
                view.updateSearchResultsTableView(image: image, for: indexPath)
            } catch {
                if Task.isCancelled { return }
                view.updateSearchResultsTableView(image: nil, for: indexPath)
                ErrorProcessing.shared.handle(error: error) { [weak view] message in
                    view?.showErrorAlert(with: Strings.AlertController.Title.imageLoadingError, message: message)
                }
            }
        }
        imageTasks.append(task)
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
    
    func cellClicked(at indexPath: IndexPath) {
        let searchData = interactor.getSearchData()
        router.showAnimeView(with: searchData[indexPath.row])
    }
    
    func randomAnimeViewTapped() {
        let data = interactor.getRandomAnimeData()
        guard let data else {
            return
        }
        router.showAnimeView(with: data)
    }
}
