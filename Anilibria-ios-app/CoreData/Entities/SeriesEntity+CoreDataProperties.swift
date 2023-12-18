//
//  SeriesEntity+CoreDataProperties.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.12.2023.
//
//

import Foundation
import CoreData

extension SeriesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SeriesEntity> {
        return NSFetchRequest<SeriesEntity>(entityName: "SeriesEntity")
    }

    @NSManaged public var numberOfSerie: Double
    @NSManaged public var duration: Double
    @NSManaged public var playbackPosition: Double
    @NSManaged public var watchedDate: Date?
    @NSManaged public var watching: WatchingEntity?

}

extension SeriesEntity: Identifiable {

}
