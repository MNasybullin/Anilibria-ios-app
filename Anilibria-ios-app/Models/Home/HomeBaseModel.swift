//
//  HomeBaseModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import UIKit

class HomeBaseModel {
    typealias DataBlock = ([AnimePosterItem], HomeView.Section)
    typealias ResultDataBlock = (Result<DataBlock, Error>) -> Void
    
    var rawData: [TitleAPIModel] = []
    var isDataTaskLoading = false
    var isImageTasksLoading = AsyncDictionary<String, Bool>()
    
    weak var output: HomeModelOutput?

    func requestImage(from item: AnimePosterItem) {
        guard !item.imageUrlString.isEmpty else { return }
        let urlString = item.imageUrlString
        Task {
            guard await isImageTasksLoading.get(urlString) != true else { return }
            await isImageTasksLoading.set(urlString, value: true)
            do {
                let imageData = try await ImageLoaderService.shared.getImageData(from: urlString)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                await isImageTasksLoading.set(urlString, value: false)
                output?.updateImage(for: item, image: image)
            } catch {
                await isImageTasksLoading.set(urlString, value: nil)
                print(error)
            }
        }
    }
}
