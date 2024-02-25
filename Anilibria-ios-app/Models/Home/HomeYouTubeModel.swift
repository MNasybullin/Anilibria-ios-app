//
//  HomeYouTubeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.12.2023.
//

import Foundation

final class HomeYouTubeModel: ImageModel {
    private let publicApiService = PublicApiService()
    private var rawData: [YouTubeAPIModel] = []
    
    func requestData() async throws -> [HomePosterItem] {
        let data = try await publicApiService.youTube(page: 1, itemsPerPage: 10)
        rawData = data.list
        let homePosters = data.list.map { HomePosterItem(fromYouTubeAPIModel: $0) }
        return homePosters
    }
        
    func getRawData(row: Int) -> YouTubeAPIModel? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[row]
    }
    
    func getRawData() -> [YouTubeAPIModel] {
        return rawData
    }
}
