//
//  HomeTodayModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

final class HomeTodayModel: ImageModel {    
    private let publicApiService = PublicApiService()
    private var rawData: [TitleAPIModel] = []
    
    func requestData() async throws -> [HomePosterItem] {
        let data = try await publicApiService.titleSchedule(withDays: [.currentDayOfTheWeek()])
        guard let todayTitleModels = data.first?.list else {
            throw MyInternalError.failedToFetchData
        }
        rawData = todayTitleModels
        let homePosters = todayTitleModels.map { HomePosterItem(fromTitleAPIModel: $0) }
        return homePosters
    }
    
    func getRawData(row: Int) -> TitleAPIModel? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[row]
    }
}
