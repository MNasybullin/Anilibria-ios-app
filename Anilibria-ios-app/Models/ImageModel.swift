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
    
    @SynchronizedLock private var imageTasks: [String: ImageTask] = [:]
}

// MARK: - Private methods

private extension ImageModel {
    func existingTask(_ task: ImageTask) async throws -> UIImage {
        guard task.isCancelled == false else {
            throw CancellationError()
        }
        
        return try await task.value
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
    func requestImage(fromUrlString urlString: String) async throws -> UIImage {
        guard !urlString.isEmpty else {
            throw MyImageError.invalidURL
        }
        
        guard let existingImageTask = imageTasks[urlString] else {
            let task = ImageTask(priority: .high) {
                let imageData = try await ImageLoaderService.shared.getImageData(fromURLString: urlString)
                
                if let downsampleSize = downsampleSize {
                    guard let downsampleImage = downsample(imageAt: imageData, to: downsampleSize) else {
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
            
            do {
                return try await existingTask(task)
            } catch {
                throw error
            }
        }
        
        do {
            return try await existingTask(existingImageTask)
        } catch {
            throw error
        }
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
