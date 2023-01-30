//
//  Alert.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.01.2023.
//

import Foundation
import UIKit

struct Alert {
    static func showErrorAlert(on viewController: UIViewController, with title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            // Все в main потоке из-за: Если два потока вызовут эту функцию, то приложение крашится (Zombie objects или double free) в UIAlertController
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: Strings.AlertController.Title.ok, style: .default)
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true, completion: completion)
        }
    }
}
