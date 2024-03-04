//
//  ScheduleModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import Foundation

final class ScheduleModel: ImageModel {
    private let publicApiService = PublicApiService()
    
    private var rawData: [ScheduleAPIModel] = []
    
    func requestData() async throws -> [ScheduleItem] {
        let data = try await publicApiService.titleSchedule(withDays: DaysOfTheWeek.allCases)
        rawData = data
        let scheduleItem = data.map { ScheduleItem(scheduleAPIModel: $0) }
        return scheduleItem
    }
    
    func getRawData(indexPath: IndexPath) -> TitleAPIModel? {
        return rawData[safe: indexPath.section]?.list[safe: indexPath.row]
    }
}
