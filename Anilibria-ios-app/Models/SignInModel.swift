//
//  SignInModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import Foundation

final class SignInModel {
    typealias ResultBlock = Result<String, Error>
    
    private let authorizationService = AuthorizationService()
    
    func authorization(email: String, password: String,
                       completionHandler: @escaping (ResultBlock) -> Void) {
        Task {
            do {
                let user = try await authorizationService.login(email: email, password: password)
                
                if user.key == KeyLoginAPI.success.rawValue || user.key == KeyLoginAPI.authorized.rawValue {
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
