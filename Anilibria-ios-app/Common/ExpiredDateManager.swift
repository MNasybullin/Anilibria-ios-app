//
//  ExpiredDateManager.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.01.2024.
//

import Foundation

final class ExpiredDateManager {
    private(set) var expireTimeInSeconds: Double
    
    private var expiredDate: Date?
    
    init(expireTimeInSeconds: Double) {
        self.expireTimeInSeconds = expireTimeInSeconds
    }
    
    convenience init(expireTimeInMinutes: Double) {
        self.init(expireTimeInSeconds: expireTimeInMinutes * 60)
    }
    
    func start() {
        var date = Date()
        date.addTimeInterval(expireTimeInSeconds)
        expiredDate = date
    }
    
    func isExpired() -> Bool {
        guard let expiredDate else { return false }
        return Date().compare(expiredDate) == .orderedDescending
    }
}
