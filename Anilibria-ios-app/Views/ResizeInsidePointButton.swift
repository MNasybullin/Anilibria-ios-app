//
//  ResizeInsidePointButton.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.02.2024.
//

import UIKit

final class ResizeInsidePointButton: UIButton {
    /// Default = (dx: 0, dy: 0)
    var insetBy: (dx: CGFloat, dy: CGFloat) = (dx: 0, dy: 0)
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: insetBy.dx, dy: insetBy.dx).contains(point)
    }
}
