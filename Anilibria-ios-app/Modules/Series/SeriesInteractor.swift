//
//  SeriesInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import UIKit

protocol SeriesInteractorProtocol: AnyObject {
	var presenter: SeriesPresenterProtocol! { get set }
    
    func getData() -> AnimeModel
    func requestImage(forIndex index: Int) async throws -> UIImage?
}

final class SeriesInteractor: SeriesInteractorProtocol {
    unowned var presenter: SeriesPresenterProtocol!
    
    private var data: AnimeModel
    
    init(data: AnimeModel) {
        self.data = data
    }
    
    func getData() -> AnimeModel {
        return data
    }
    
    func requestImage(forIndex index: Int) async throws -> UIImage? {
        guard let imageURL = data.playlist[index].preview else {
            throw MyInternalError.failedToFetchURLFromData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            return UIImage(data: imageData)
        } catch {
            throw error
        }
    }
}
