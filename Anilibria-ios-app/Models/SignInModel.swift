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
        Task(priority: .userInitiated) {
            do {
                let user = try await authorizationService.login(email: email, password: password)
                
                if user.key == KeyLoginAPI.success.rawValue {
                    completionHandler(.success(user.key))
                } else if user.key == KeyLoginAPI.authorized.rawValue {
                    try? await authorizationService.logout()
//                    authorization(email: email, password: password, completionHandler: completionHandler)
                    let error = NSError(domain: "Неизвестная ошибка, попробуйте еще.", code: 0)
                    completionHandler(.failure(error))
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
