//
//  HomeYouTubeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.12.2023.
//

import Foundation

final class HomeYouTubeModel: ImageModel, HomeModelInput {
    weak var homeModelOutput: HomeModelOutput?
    
    private let publicApiService = PublicApiService()
    
    private var rawData: [YouTubeAPIModel] = []
    private var pangination: ListPangination = .initialData()
    var isDataTaskLoading = false
    
    func requestData() {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task(priority: .userInitiated) {
            defer { isDataTaskLoading = false }
            do {
                let data = try await publicApiService.youTube(page: pangination.currentPage + 1, itemsPerPage: 10)
                pangination = data.pagination
                rawData = data.list
                let homePosters = data.list.map { HomePosterItem(fromYouTubeAPIModel: $0) }
                homeModelOutput?.updateData(items: homePosters, section: .youtube)
            } catch {
                homeModelOutput?.failedRequestData(error: error)
            }
        }
    }
        
    func getRawData(row: Int) -> Any? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[row]
    }
    
    func getRawData() -> [Any] {
        return rawData
    }
}
