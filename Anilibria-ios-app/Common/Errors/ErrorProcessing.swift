//
//  ErrorProcessing.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.01.2023.
//

import Foundation

class ErrorProcessing {
    
    // MARK: - Singleton
    static let shared: ErrorProcessing = ErrorProcessing()
    
    func handle(error: Error, showErrorAlertWith: (_ message: String) -> Void) {
        var message: String?
        switch error {
            case let networkError as MyNetworkError:
                message = networkError.localizedDescription
            case let internalError as MyInternalError:
                message = internalError.localizedDescription
            case let imageError as MyImageError:
                message = imageError.localizedDescription
            case let nsError as NSError:
                message = getMessageFrom(nsError: nsError)
            default:
                message = error.localizedDescription
        }
        guard let message = message else {
            return
        }
        showErrorAlertWith(message)
    }
    
    private func getMessageFrom(nsError: NSError) -> String? {
        switch nsError.code {
            case -1020:
                // No Connected To Internet
                RootViewController.shared.showFlashNetworkActivityView()
                return nil
            default:
                return nsError.localizedDescription + " Code = \(nsError.code)."
        }
    }
}
