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
    
    func getSearchData() -> [TitleAPIModel]
    func getRandomAnimeData() -> TitleAPIModel?
    func deleteSearchResultsData()
    func requestImage(forIndexPath indexPath: IndexPath) async throws -> UIImage
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsModel], Bool)
    func requestRandomAnimeData() async throws -> RandomAnimeViewModel
}

final class SearchInteractor: SearchInteractorProtocol {
    weak var presenter: SearchPresenterProtocol!
    
    private var searchResults = [TitleAPIModel]()
    private var randomAnime: TitleAPIModel?
    
    func deleteSearchResultsData() {
        searchResults.removeAll()
    }
    
    func getSearchData() -> [TitleAPIModel] {
        return searchResults
    }
    
    func getRandomAnimeData() -> TitleAPIModel? {
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
        let imageURL = searchResults[indexPath.row].posters.original.url
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
            let imageURL = titleModel.posters.original.url
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            image = UIImage(data: imageData)
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
