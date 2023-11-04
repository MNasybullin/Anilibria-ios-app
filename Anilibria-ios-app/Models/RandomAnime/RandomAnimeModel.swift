//
//  RandomAnimeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

protocol RandomAnimeModelDelegate: AnyObject {
    func update(data: RandomAnimeItem)
    func failedRequestData(error: Error)
}

final class RandomAnimeModel {
    typealias ResultDataBlock = (Result<RandomAnimeItem, Error>) -> Void
    private (set) var isDataTaskLoading = false
    private var rawData: TitleAPIModel?
    
    weak var delegate: RandomAnimeModelDelegate?
    
    private func requestData(completionHandler: @escaping ResultDataBlock) {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task {
            defer { isDataTaskLoading = false }
            do {
                let titleModel = try await PublicApiService.shared.getRandomTitle()
                let imageURL = titleModel.posters.original.url
                let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                rawData = titleModel
                let randomAnimeItem = RandomAnimeItem(from: titleModel, image: image)
                completionHandler(.success(randomAnimeItem))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    func requestData() {
        requestData { [weak self] result in
            switch result {
                case .success(let data):
                    self?.delegate?.update(data: data)
                case .failure(let error):
                    self?.delegate?.failedRequestData(error: error)
            }
        }
    }
    
    func getRawData() -> TitleAPIModel? {
        return rawData
    }
}
