//
//  UserEntity+CoreDataProperties.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.12.2023.
//
//

import Foundation
import CoreData
import UIKit

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var image: UIImage
    @NSManaged public var imageUrl: String
    @NSManaged public var name: String

}

extension UserEntity: Identifiable {

}
