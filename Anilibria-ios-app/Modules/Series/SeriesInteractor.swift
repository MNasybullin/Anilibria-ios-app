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
    func requestImage(forIndex index: Int) async throws -> UIImage
    func requestCachingNodes() async throws -> String
}

final class SeriesInteractor: SeriesInteractorProtocol {
    weak var presenter: SeriesPresenterProtocol!
    
    private var data: AnimeModel
    
    init(data: AnimeModel) {
        self.data = data
    }
    
    func getData() -> AnimeModel {
        return data
    }
    
    func requestImage(forIndex index: Int) async throws -> UIImage {
        guard let imageURL = data.playlist[index].preview else {
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
    
    func requestCachingNodes() async throws -> String {
        do {
            let cachingNodes = try await PublicApiService.shared.getCachingNodes()
            guard let cachingNode = cachingNodes.first else {
                throw MyInternalError.failedToFetchData
            }
            return cachingNode
        } catch {
            throw error
        }
    }
}
