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
    var isDataTaskLoading = false
    
    func requestData() {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task(priority: .userInitiated) {
            defer { isDataTaskLoading = false }
            do {
                let data = try await publicApiService.getYouTube(withLimit: 10)
                rawData = data
                let homePosters = data.map { HomePosterItem(fromYouTubeAPIModel: $0) }
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
}
