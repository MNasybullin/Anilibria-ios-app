//
//  ImageModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import UIKit

class ImageModel {
    typealias ImageTask = Task<UIImage, Error>
    
    var downsampleSize: CGSize?
    private var imageTasks = ThreadSafeDictionary<String, ImageTask>()
}

// MARK: - Private methods

private extension ImageModel {
    func downsample(imageAt imageData: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) throws -> UIImage {
        
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions) else {
            throw MyImageError.failedToDownSampling
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
            throw MyImageError.failedToDownSampling
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}

// MARK: - Internal methods

extension ImageModel {
    func requestImage(fromUrlString urlString: String) async throws -> UIImage {
        guard !urlString.isEmpty else {
            throw MyImageError.invalidURL
        }
        
        if let existingImageTask = imageTasks[urlString] {
            return try await existingImageTask.value
        }
        
        let task = ImageTask(priority: .high) {
            let imageData = try await ImageLoaderService.shared.getImageData(fromURLString: urlString)
            
            if let downsampleSize = downsampleSize {
                return try downsample(imageAt: imageData, to: downsampleSize)
            } else {
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                return image
            }
        }
        
        imageTasks[urlString] = task
        return try await task.value
    }
    
    func cancelImageTasks() {
        imageTasks.values.forEach { $0.cancel() }
        imageTasks.removeAll()
    }
    
    func cancelImageTask(forUrlString urlString: String) {
        let task = imageTasks.removeValue(forKey: urlString)
        task?.cancel()
    }
}
