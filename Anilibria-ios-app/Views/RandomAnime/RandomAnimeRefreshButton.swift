//
//  RandomAnimeRefreshButton.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.11.2023.
//

import UIKit

final class RandomAnimeRefreshButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -15, dy: -15).contains(point)
    }
}
