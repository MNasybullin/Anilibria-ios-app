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
    
    func requestImage(forIndex index: Int) async throws -> UIImage?
    func requestData() async throws -> [AnimeTableViewModel]
    func requestRandomAnimeData() async throws -> RandomAnimeViewModel
}

final class SearchInteractor: SearchInteractorProtocol {
    unowned var presenter: SearchPresenterProtocol!
    
    private var animeTable: [GetTitleModel]?
    private var randomAnime: GetTitleModel?
    
    func requestData() async throws -> [AnimeTableViewModel] {
        do {
            let titleModels = try await PublicApiService.shared.searchTitles(genres: "комедия")
            animeTable = titleModels
            var animeTableViewModel = [AnimeTableViewModel]()
            titleModels.forEach { item in
                animeTableViewModel.append(AnimeTableViewModel(ruName: item.names.ru, engName: item.names.en, description: item.description))
            }
            return animeTableViewModel
        } catch {
            throw error
        }
    }
    
    func requestImage(forIndex index: Int) async throws -> UIImage? {
        guard let imageURL = animeTable?[index].posters?.original?.url else {
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
