//
//  ImageModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import UIKit

protocol ImageModelDelegate: AnyObject {
    func failedRequestImage(error: Error)
}

class ImageModel {
    typealias ImageTask = Task<UIImage, Error>
    weak var imageModelDelegate: ImageModelDelegate?
    
    private var imageTasks: [String: ImageTask] = [:]
}

// MARK: - Private methods

private extension ImageModel {
    func existingTask(_ task: ImageTask, successCompletion: @escaping (UIImage) -> Void) {
        guard task.isCancelled == false else {
            return
        }
        Task {
            let result = await task.result
            guard task.isCancelled == false else {
                return
            }
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        successCompletion(image)
                    }
                case .failure(let error):
                    imageModelDelegate?.failedRequestImage(error: error)
            }
        }
    }
}

// MARK: - Internal methods

extension ImageModel {
    func requestImage(from urlString: String, successCompletion: @escaping (UIImage) -> Void) {
        guard urlString.isEmpty == false else { return }
        guard imageTasks[urlString] == nil else {
            existingTask(imageTasks[urlString]!, successCompletion: successCompletion)
            return
        }
        let task = ImageTask(priority: .medium) {
            let imageData = try await ImageLoaderService.shared.getImageData(from: urlString)
            guard let image = UIImage(data: imageData) else {
                throw MyImageError.failedToInitialize
            }
            return image
        }
        imageTasks[urlString] = task
        existingTask(task, successCompletion: successCompletion)
    }
    
    func cancelImageTasks() {
        imageTasks.values.forEach { $0.cancel() }
        imageTasks.removeAll()
    }
}
