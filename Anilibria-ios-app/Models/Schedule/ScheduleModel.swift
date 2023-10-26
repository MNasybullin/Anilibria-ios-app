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

final class ScheduleModel: AnimePosterModel {
    weak var scheduleModelOutput: ScheduleModelOutput?
    
    func requestData() {
        Task {
            do {
                let data = try await PublicApiService.shared.getSchedule(with: DaysOfTheWeek.allCases)
                let scheduleItem = data.map { ScheduleItem(scheduleAPIModel: $0) }
                scheduleModelOutput?.update(data: scheduleItem)
            } catch {
                scheduleModelOutput?.failedRequestData(error: error)
            }
        }
    }
}
