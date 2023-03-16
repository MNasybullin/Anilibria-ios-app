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
    
    func deleteSearchResultsData()
    func requestImage(forIndexPath indexPath: IndexPath) async throws -> UIImage?
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsRowsModel], Bool)
    func requestRandomAnimeData() async throws -> RandomAnimeViewModel
}

final class SearchInteractor: SearchInteractorProtocol {
    unowned var presenter: SearchPresenterProtocol!
    
    private struct Section {
        var rowsData: [GetTitleModel]?
    }
    
    private var searchResultsSection = [Section]()
    private var randomAnime: GetTitleModel?
    
    func deleteSearchResultsData() {
        searchResultsSection.removeAll()
    }
    
    func searchTitles(searchText: String, after value: Int) async throws -> ([SearchResultsRowsModel], Bool) {
        do {
            let limit: Int = 15
            let titleModels = try await PublicApiService.shared.searchTitles(withSearchText: searchText, withLimit: limit, after: value)
            searchResultsSection.append(Section(rowsData: titleModels))
            var searchResultsRowsModel = [SearchResultsRowsModel]()
            titleModels.forEach { item in
                searchResultsRowsModel.append(SearchResultsRowsModel(ruName: item.names.ru, engName: item.names.en, description: item.description))
            }
            let needLoadMoreData = titleModels.count == limit
            return (searchResultsRowsModel, needLoadMoreData)
        } catch {
            throw error
        }
    }
    
    func requestImage(forIndexPath indexPath: IndexPath) async throws -> UIImage? {
        guard let imageURL = searchResultsSection[indexPath.section].rowsData?[indexPath.row].posters?.original?.url else {
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
