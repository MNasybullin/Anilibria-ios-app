//
//  AppOrientation.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.11.2023.
//

import UIKit

final class AppOrientation {
    static func updateOrientation(to viewController: UIViewController, _ orientation: UIInterfaceOrientationMask, animated: Bool) {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.currentOrientationMode = orientation
        if animated {
            update(viewController)
        } else {
            UIView.performWithoutAnimation {
                update(viewController)
            }
        }
    }
    
    private static func update(_ viewController: UIViewController) {
        if #available(iOS 16.0, *) {
            viewController.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
