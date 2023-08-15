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
    
    func getSearchData() -> [GetTitleModel]
    func getRandomAnimeData() -> GetTitleModel?
    func deleteSearchResultsData()
    func requestImage(forIndexPath indexPath: IndexPath) async throws -> UIImage
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsModel], Bool)
    func requestRandomAnimeData() async throws -> RandomAnimeViewModel
}

final class SearchInteractor: SearchInteractorProtocol {
    unowned var presenter: SearchPresenterProtocol!
    
    private var searchResults = [GetTitleModel]()
    private var randomAnime: GetTitleModel?
    
    func deleteSearchResultsData() {
        searchResults.removeAll()
    }
    
    func getSearchData() -> [GetTitleModel] {
        return searchResults
    }
    
    func getRandomAnimeData() -> GetTitleModel? {
        return randomAnime
    }
    
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsModel], Bool) {
        do {
            let limit: Int = 15
            let titleModels = try await PublicApiService.shared.searchTitles(withSearchText: searchText, withLimit: limit, after: value)
            searchResults.append(contentsOf: titleModels)
            var searchResultsModel = [SearchResultsModel]()
            titleModels.forEach { item in
                searchResultsModel.append(SearchResultsModel(ruName: item.names.ru, engName: item.names.en, description: item.description))
            }
            let needLoadMoreData = titleModels.count == limit
            return (searchResultsModel, needLoadMoreData)
        } catch {
            throw error
        }
    }
    
    func requestImage(forIndexPath indexPath: IndexPath) async throws -> UIImage {
        guard let imageURL = searchResults[indexPath.row].posters?.original?.url else {
            throw MyInternalError.failedToFetchURLFromData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            guard let image = UIImage(data: imageData) else {
                throw MyImageError.failedToInitialize
            }
            return image
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
