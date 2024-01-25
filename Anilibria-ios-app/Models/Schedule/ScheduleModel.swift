//
//  ScheduleModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import Foundation

protocol ScheduleModelOutput: AnyObject {
    func update(data: [ScheduleItem])
    func failedRequestData(error: Error)
}

final class ScheduleModel: ImageModel {
    weak var scheduleModelOutput: ScheduleModelOutput?
    
    private let publicApiService = PublicApiService()
    
    private var rawData: [ScheduleAPIModel] = []
    
    func requestData() {
        Task(priority: .userInitiated) {
            do {
                let data = try await publicApiService.titleSchedule(withDays: DaysOfTheWeek.allCases)
                rawData = data
                let scheduleItem = data.map { ScheduleItem(scheduleAPIModel: $0) }
                scheduleModelOutput?.update(data: scheduleItem)
            } catch {
                scheduleModelOutput?.failedRequestData(error: error)
            }
        }
    }
    
    func getRawData(indexPath: IndexPath) -> TitleAPIModel? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[indexPath.section].list[indexPath.row]
    }
}
