//
//  SignInModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import Foundation

final class SignInModel {
    typealias ResultBlock = Result<String, Error>
    
    func authorization(email: String, password: String,
                       completionHandler: @escaping (ResultBlock) -> Void) {
        Task {
            do {
                let user = try await AuthorizationService.shared.login(email: email, password: password)
                
                if user.key == KeyLogin.success.rawValue || user.key == KeyLogin.authorized.rawValue {
                    completionHandler(.success(user.key))
                } else {
                    let error = NSError(domain: user.key, code: 0)
                    completionHandler(.failure(error))
                }
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}
