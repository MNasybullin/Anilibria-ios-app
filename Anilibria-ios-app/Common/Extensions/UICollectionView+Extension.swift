//
//  UICollectionView+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.03.2024.
//

import UIKit

extension UICollectionView {
    func animateCellHighlight(at indexPath: IndexPath, highlighted: Bool, lastTransform: CGAffineTransform? = nil) {
        guard let cell = self.cellForItem(at: indexPath) else {
            return
        }
        let scale = 0.97
        let alpha = highlighted ? 0.9 : 1.0
        let transform: CGAffineTransform
        if highlighted {
            transform = cell.transform.scaledBy(x: scale, y: scale)
        } else {
            transform = lastTransform ?? .identity
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
            cell.alpha = alpha
            cell.transform = transform
        }
    }
}
