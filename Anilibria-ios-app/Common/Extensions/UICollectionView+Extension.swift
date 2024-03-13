//
//  UICollectionView+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.03.2024.
//

import UIKit

extension UICollectionView {
    func animateCellHighlight(at indexPath: IndexPath, highlighted: Bool) {
        guard let cell = self.cellForItem(at: indexPath) else {
            return
        }
        let scale = highlighted ? 0.97 : 1.0
        let alpha = highlighted ? 0.9 : 1.0
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
            cell.alpha = alpha
            cell.transform = transform
        }
    }
}
