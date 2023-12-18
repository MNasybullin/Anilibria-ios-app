//
//  UIImageTransformer.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.12.2023.
//

import Foundation
import UIKit

class UIImageTransformer: NSSecureUnarchiveFromDataTransformer {
    static func register() {
        let className = String(describing: UIImageTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = UIImageTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
    override static var allowedTopLevelClasses: [AnyClass] {
        [UIImage.self]
    }
}
