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
    var downsampleSize: CGSize?
    
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
    
    func downsample(imageAt imageData: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
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
        let task = ImageTask(priority: .high) {
            let imageData = try await ImageLoaderService.shared.getImageData(fromURLString: urlString)
            if downsampleSize != nil {
                guard let downsampleImage = downsample(imageAt: imageData, to: downsampleSize!) else {
                    throw MyImageError.failedToInitialize
                }
                return downsampleImage
            } else {
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                return image
            }
        }
        imageTasks[urlString] = task
        existingTask(task, successCompletion: successCompletion)
    }
    
    func cancelImageTasks() {
        imageTasks.values.forEach { $0.cancel() }
        imageTasks.removeAll()
    }
}
