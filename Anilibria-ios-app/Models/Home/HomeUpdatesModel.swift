//
//  HomeUpdatesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

final class HomeUpdatesModel: ImageModel {
    private let publicApiService = PublicApiService()
    private var rawData: [TitleAPIModel] = []
    
    func requestData() async throws -> [HomePosterItem] {
        let data = try await publicApiService.titleUpdates(page: 1)
        rawData = data.list
        let homePosters = data.list.map { HomePosterItem(fromTitleAPIModel: $0) }
        return homePosters
    }
        
    func getRawData(row: Int) -> TitleAPIModel? {
        return rawData[safe: row]
    }
}
