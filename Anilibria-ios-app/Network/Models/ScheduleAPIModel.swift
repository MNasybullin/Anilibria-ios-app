//
//  ScheduleAPIModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.08.2022.
//

import Foundation

/// Возвращается в запросах:
/// getSchedule
struct ScheduleAPIModel: Decodable {
    let day: DaysOfTheWeek
    let list: [TitleAPIModel]
}

/// Счет дней недели идет с понедельника, где 0 - Понедельник, а 6 - Воскресенье.
enum DaysOfTheWeek: Int, Decodable, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static func currentDayOfTheWeek() -> DaysOfTheWeek {
        let date = Date()
        var weekday = Calendar.current.component(.weekday, from: date)
        // enum DaysOfTheWeek (0 - Понедельник), а по Calendar (2 - Понедельник)
        weekday -= 2
        weekday = weekday < 0 ? 6 : weekday
        return DaysOfTheWeek(rawValue: weekday)!
    }
}

extension DaysOfTheWeek: CustomStringConvertible {
    var description: String {
        switch self {
            case .monday:
                return Strings.DaysOfTheWeek.monday
            case .tuesday:
                return Strings.DaysOfTheWeek.tuesday
            case .wednesday:
                return Strings.DaysOfTheWeek.wednesday
            case .thursday:
                return Strings.DaysOfTheWeek.thursday
            case .friday:
                return Strings.DaysOfTheWeek.friday
            case .saturday:
                return Strings.DaysOfTheWeek.saturday
            case .sunday:
                return Strings.DaysOfTheWeek.sunday
        }
    }
}
