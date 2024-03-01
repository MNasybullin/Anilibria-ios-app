//
//  Alert.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.01.2023.
//

import Foundation
import UIKit

struct Alert {
    static func showErrorAlert(on viewController: UIViewController, title: String, message: String, buttonActionCompletion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: Strings.AlertController.Title.ok, style: .default) { _ in
                buttonActionCompletion?()
            }
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true)
        }
    }
}
