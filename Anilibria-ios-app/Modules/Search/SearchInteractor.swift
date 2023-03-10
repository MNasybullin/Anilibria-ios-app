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
}

final class SearchInteractor: SearchInteractorProtocol {
    unowned var presenter: SearchPresenterProtocol!
    
    private var getTitleModel: [GetTitleModel]?
    
    func requestData() async throws -> [AnimeTableViewModel] {
        do {
            let titleModel = try await PublicApiService.shared.getRandomTitle()
            getTitleModel = [titleModel]
            return [AnimeTableViewModel(ruName: titleModel.names.ru, engName: titleModel.names.en, description: titleModel.description)]
        } catch {
            throw error
        }
    }
    
    func requestImage(forIndex index: Int) async throws -> UIImage? {
        guard let imageURL = getTitleModel?[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            return UIImage(data: imageData)
        } catch {
            throw error
        }
    }
}
