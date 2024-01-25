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

final class SearchResultsModel: ImageModel {
    private enum Constants {
        static let limitResults: Int = 15
    }
    
    private let publicApiService = PublicApiService()
    
    private var rawData: [TitleAPIModel] = []
    private var pangination: ListPangination = .initialData()
    private var loadingDataTask: Task<(), Never>?
    private (set) var needLoadMoreData: Bool = true
    
    weak var delegate: SearchResultsModelDelegate?
    
    func searchTitles(searchText: String, after value: Int) {
        loadingDataTask?.cancel()
        loadingDataTask = Task(priority: .userInitiated) {
            defer {
                loadingDataTask = nil
            }
            do {
                let titleModelsList = try await publicApiService.titleSearch(
                    withSearchText: searchText,
                    page: pangination.currentPage + 1, itemsPerPage: Constants.limitResults)
                if Task.isCancelled == true {
                    return
                }
                pangination = titleModelsList.pagination
                rawData.append(contentsOf: titleModelsList.list)
                let result = titleModelsList.list.map {
                    SearchResultsItem(from: $0, image: nil)
                }
                needLoadMoreData = titleModelsList.list.count == Constants.limitResults
                delegate?.update(newData: result, afterValue: value)
            } catch {
                if Task.isCancelled == true {
                    return
                }
                delegate?.failedRequestData(error: error, afterValue: value)
            }
        }
    }
    
    func cancelTasks() {
        cancelImageTasks()
        
        loadingDataTask?.cancel()
        loadingDataTask = nil
    }
    
    func deleteData() {
        needLoadMoreData = true
        rawData.removeAll()
        pangination = .initialData()
    }
    
    func getRawData(row: Int) -> TitleAPIModel? {
        guard rawData.isEmpty == false else {
            return nil
        }
        return rawData[row]
    }
}
