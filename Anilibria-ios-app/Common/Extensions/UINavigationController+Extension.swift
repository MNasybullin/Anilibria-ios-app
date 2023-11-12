//
//  UINavigationController+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.03.2023.
//

import UIKit

// https://stackoverflow.com/questions/48954413/how-to-enable-swipe-gesture-when-navigation-bar-is-hidden
extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
