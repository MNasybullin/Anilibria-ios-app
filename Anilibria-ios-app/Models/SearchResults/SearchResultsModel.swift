//
//  SearchResultsModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.11.2023.
//

import UIKit

protocol SearchResultsModelDelegate: AnyObject {
    func update(newData: [SearchResultsItem], afterValue: Int)
    func failedRequestData(error: Error, afterValue: Int)
    func failedRequestImage(error: Error)
}

final class SearchResultsModel {
    typealias ImageTask = Task<UIImage, Error>
    private enum Constants {
        static let limitResults: Int = 15
    }
    
    private var rawData: [TitleAPIModel] = []
    private var loadingDataTask: Task<(), Never>?
    private (set) var needLoadMoreData: Bool = true
    
    private var imageTasks: [String: ImageTask] = [:]
    
    weak var delegate: SearchResultsModelDelegate?
    
    func searchTitles(searchText: String, after value: Int) {
        loadingDataTask?.cancel()
        loadingDataTask = Task(priority: .userInitiated) {
            defer {
                loadingDataTask = nil
            }
            do {
                let titleModels = try await PublicApiService.shared.searchTitles(
                    withSearchText: searchText,
                    withLimit: Constants.limitResults,
                    after: value)
                if Task.isCancelled == true {
                    return
                }
                rawData.append(contentsOf: titleModels)
                let result = titleModels.map {
                    SearchResultsItem(from: $0, image: nil)
                }
                needLoadMoreData = titleModels.count == Constants.limitResults
                delegate?.update(newData: result, afterValue: value)
            } catch {
                if Task.isCancelled == true {
                    return
                }
                delegate?.failedRequestData(error: error, afterValue: value)
            }
        }
    }
    
    func requestImage(from urlString: String, successCompletion: @escaping (UIImage) -> Void) {
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
    
    private func existingTask(_ task: ImageTask, successCompletion: @escaping (UIImage) -> Void) {
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
                    delegate?.failedRequestImage(error: error)
            }
        }
    }
    
    func cancelTasks() {
        imageTasks.values.forEach { $0.cancel() }
        imageTasks.removeAll()
        
        loadingDataTask?.cancel()
        loadingDataTask = nil
    }
    
    func deleteData() {
        needLoadMoreData = true
        rawData.removeAll()
    }
    
    func getRawData(row: Int) -> TitleAPIModel? {
        guard rawData.isEmpty == false else {
            return nil
        }
        return rawData[row]
    }
}
