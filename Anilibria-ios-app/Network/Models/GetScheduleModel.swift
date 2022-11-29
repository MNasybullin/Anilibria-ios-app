//
//  GetScheduleModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.08.2022.
//

import Foundation

/// Возвращается в запросах:
/// getSchedule
struct GetScheduleModel: Codable {
    let day: DaysOfTheWeek
    var list: [GetTitleModel]
}

/// Счет дней недели идет с понедельника, где 0 - Понедельник, а 6 - Воскресенье.
enum DaysOfTheWeek: Int, Codable {
    case monday = 0,
         tuesday = 1,
         wednesday = 2,
         thursday = 3,
         friday = 4,
         saturday = 5,
         sunday = 6
}
