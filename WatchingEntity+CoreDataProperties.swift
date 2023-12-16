//
//  WatchingEntity+CoreDataProperties.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.12.2023.
//
//

import Foundation
import CoreData

extension WatchingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WatchingEntity> {
        return NSFetchRequest<WatchingEntity>(entityName: "WatchingEntity")
    }

    @NSManaged public var animeId: Int64
    @NSManaged public var user: UserEntity?
    @NSManaged public var series: NSSet?

}

// MARK: Generated accessors for series
extension WatchingEntity {

    @objc(addSeriesObject:)
    @NSManaged public func addToSeries(_ value: SeriesEntity)

    @objc(removeSeriesObject:)
    @NSManaged public func removeFromSeries(_ value: SeriesEntity)

    @objc(addSeries:)
    @NSManaged public func addToSeries(_ values: NSSet)

    @objc(removeSeries:)
    @NSManaged public func removeFromSeries(_ values: NSSet)

}

extension WatchingEntity: Identifiable {

}
