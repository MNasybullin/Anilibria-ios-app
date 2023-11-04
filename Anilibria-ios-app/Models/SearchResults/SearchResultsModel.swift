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
    func update(image: UIImage, indexPath: IndexPath)
    func failedRequestImage(error: Error)
}

final class SearchResultsModel {
    private enum Constants {
        static let limitResults: Int = 15
    }
    
    private var rawData: [TitleAPIModel] = []
    private var loadingDataTask: Task<(), Never>?
    private (set) var needLoadMoreData: Bool = true
    
    private var isImageTasksLoading = AsyncDictionary<String, Bool>()
    private var loadingImageTasks: [Task<(), Never>] = []
    
    weak var delegate: SearchResultsModelDelegate?
    
    func searchTitles(searchText: String, after value: Int) {
        loadingDataTask?.cancel()
        loadingDataTask = Task {
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
    
    func requestImage(from urlString: String, indexPath: IndexPath) {
        guard !urlString.isEmpty else { return }
        let task = Task {
            guard await isImageTasksLoading.get(urlString) != true else { return }
            await isImageTasksLoading.set(urlString, value: true)
            do {
                let imageData = try await ImageLoaderService.shared.getImageData(from: urlString)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                await isImageTasksLoading.set(urlString, value: false)
                if Task.isCancelled == true {
                    return
                }
                delegate?.update(image: image, indexPath: indexPath)
            } catch {
                await isImageTasksLoading.set(urlString, value: nil)
                if Task.isCancelled == true {
                    return
                }
                delegate?.failedRequestImage(error: error)
            }
        }
        loadingImageTasks.append(task)
    }
    
    func cancelTasks() {
        loadingImageTasks.forEach { $0.cancel() }
        loadingImageTasks.removeAll()
        Task {
            await isImageTasksLoading.removeAll()
        }
        
        loadingDataTask?.cancel()
        loadingDataTask = nil
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
