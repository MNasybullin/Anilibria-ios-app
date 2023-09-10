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
    private init() { }
    
    func handle(error: Error, showErrorAlertWith: (_ message: String) -> Void) {
        var message: String?
        switch error {
            case let networkError as MyNetworkError:
                message = networkError.description
            case let internalError as MyInternalError:
                message = internalError.description
            case let imageError as MyImageError:
                message = imageError.description
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
