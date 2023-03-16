//
//  SearchInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.01.2023.
//

import Foundation
import UIKit

protocol SearchInteractorProtocol: AnyObject {
    var presenter: SearchPresenterProtocol! { get set }
    
    func deleteSearchResultsTableData()
    func requestImage(forIndex index: Int) async throws -> UIImage?
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsTableViewModel], Bool)
    func requestRandomAnimeData() async throws -> RandomAnimeViewModel
}

final class SearchInteractor: SearchInteractorProtocol {
    unowned var presenter: SearchPresenterProtocol!
    
    private var searchResultsTable: [GetTitleModel] = [GetTitleModel]()
    private var randomAnime: GetTitleModel?
    
    func deleteSearchResultsTableData() {
        searchResultsTable = [GetTitleModel]()
    }
    
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsTableViewModel], Bool) {
        do {
            let limit: Int = 20
            let titleModels = try await PublicApiService.shared.searchTitles(withSearchText: searchText, withLimit: limit, after: value)
            searchResultsTable += titleModels
            var searchResultsTableViewModel = [SearchResultsTableViewModel]()
            titleModels.forEach { item in
                searchResultsTableViewModel.append(SearchResultsTableViewModel(ruName: item.names.ru, engName: item.names.en, description: item.description))
            }
            let needLoadMoreData = titleModels.count >= limit ? true : false
            return (searchResultsTableViewModel, needLoadMoreData)
        } catch {
            throw error
        }
    }
    
    func requestImage(forIndex index: Int) async throws -> UIImage? {
        guard let imageURL = searchResultsTable[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            return UIImage(data: imageData)
        } catch {
            throw error
        }
    }
    
    func requestRandomAnimeData() async throws -> RandomAnimeViewModel {
        do {
            let titleModel = try await PublicApiService.shared.getRandomTitle()
            randomAnime = titleModel
            var image: UIImage?
            if let imageURL = titleModel.posters?.original?.url {
                let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
                image = UIImage(data: imageData)
            }
            return RandomAnimeViewModel(ruName: titleModel.names.ru,
                                        engName: titleModel.names.en,
                                        description: titleModel.description,
                                        image: image,
                                        imageIsLoading: false)
        } catch {
            throw error
        }
    }
}
