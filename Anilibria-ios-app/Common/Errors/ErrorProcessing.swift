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
    
    func getMessageFrom(error: Error) -> String {
        switch error {
            case let networkError as MyNetworkError:
                return networkError.localizedDescription
            case let internalError as MyInternalError:
                return internalError.localizedDescription
            case let imageError as MyImageError:
                return imageError.localizedDescription
            case let nsError as NSError:
                return getMessageFrom(nsError: nsError)
            default:
                return error.localizedDescription
        }
    }
    
    private func getMessageFrom(nsError: NSError) -> String {
        switch nsError.code {
            case -1020:
                return Strings.OtherError.noConnectedToInternet
            default:
                return nsError.localizedDescription + " Code = \(nsError.code)."
        }
    }
}
