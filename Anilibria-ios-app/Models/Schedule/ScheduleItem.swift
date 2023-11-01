//
//  ScheduleItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import Foundation

struct ScheduleItem {
    let headerName: String
    var animePosterItems: [AnimePosterItem]
}

extension ScheduleItem {
    init(scheduleAPIModel model: ScheduleAPIModel) {
        let day = model.day.description
        let items = model.list.map { AnimePosterItem(titleAPIModel: $0) }
        self.init(headerName: day, animePosterItems: items)
    }
}
