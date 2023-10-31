//
//  AnimePosterModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import UIKit

class AnimePosterModel {
    var isDataTaskLoading = false
    var isImageTasksLoading = AsyncDictionary<String, Bool>()
    
    weak var output: AnimePosterModelOutput?

    func requestImage(from imageUrlString: String, indexPath: IndexPath) {
        guard !imageUrlString.isEmpty else { return }
        Task {
            guard await isImageTasksLoading.get(imageUrlString) != true else { return }
            await isImageTasksLoading.set(imageUrlString, value: true)
            do {
                let imageData = try await ImageLoaderService.shared.getImageData(from: imageUrlString)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                await isImageTasksLoading.set(imageUrlString, value: false)
                output?.update(image: image, indexPath: indexPath)
            } catch {
                await isImageTasksLoading.set(imageUrlString, value: nil)
                output?.failedRequestImage(error: error)
            }
        }
    }
}
