//
//  TopOverlayButton.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.01.2024.
//

import UIKit

final class TopOverlayButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -16, dy: -16).contains(point)
    }
}
