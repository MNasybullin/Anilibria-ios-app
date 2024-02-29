//
//  UserModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

protocol UserModelDelegate: AnyObject {
    func authorizationSuccessful(user: UserItem)
    func authorizationFailure(error: Error)
    
    func requestFromCoreDataSuccessful(user: UserItem)
    func requestFromCoreDataFailure(error: Error)
    
    func logoutSuccessful()
    func logoutFailure(error: Error)
}

final class UserModel {
    private let authorizationService = AuthorizationService()
    private let imageLoaderService = ImageLoaderService.shared
    private let coreDataService = CoreDataService.shared
    
    weak var delegate: UserModelDelegate?
    
    func authorization(email: String, password: String) {
        Task(priority: .userInitiated) {
            do {
                let loginModel = try await authorizationService.login(email: email, password: password)
                
                if loginModel.key == KeyLoginAPI.success.rawValue {
                    let user = try await requestUser()
                    UserDefaults.standard.isUserAuthorized = true
                    delegate?.authorizationSuccessful(user: user)
                } else if loginModel.key == KeyLoginAPI.authorized.rawValue {
                    // Уже авторизован, Идет перелогин...
                    try? await authorizationService.logout()
                    authorization(email: email, password: password)
                } else {
                    let error = NSError(domain: loginModel.key, code: 0)
                    UserDefaults.standard.isUserAuthorized = false
                    UserDefaults.standard.userLogin = nil
                    delegate?.authorizationFailure(error: error)
                }
            } catch {
                UserDefaults.standard.isUserAuthorized = false
                UserDefaults.standard.userLogin = nil
                delegate?.authorizationFailure(error: error)
            }
        }
    }
    
    func getUserInfo() {
        do {
            let user = try requestUserFromCoreData()
            delegate?.requestFromCoreDataSuccessful(user: user)
        } catch {
            UserDefaults.standard.isUserAuthorized = false
            UserDefaults.standard.userLogin = nil
            delegate?.requestFromCoreDataFailure(error: error)
        }
    }
    
    func logout() {
        Task(priority: .userInitiated) {
            do {
                try await authorizationService.logout()
                UserDefaults.standard.isUserAuthorized = false
                UserDefaults.standard.userLogin = nil
                delegate?.logoutSuccessful()
            } catch {
                delegate?.logoutFailure(error: error)
            }
        }
    }
}

// MARK: - Private methods

private extension UserModel {
    func requestUserFromCoreData() throws -> UserItem {
        guard let userLogin = UserDefaults.standard.userLogin else {
            throw NSError(domain: "User id not found in UserDefaults", code: 404)
        }
        let context = coreDataService.viewContext
        let userEntity = try UserEntity.find(userLogin: userLogin, context: context)
        let user = UserItem(userEntity: userEntity)
        return user
    }
    
    func requestUser() async throws -> UserItem {
        let userApiModel = try await authorizationService.user()
        var user = UserItem(userApiModel: userApiModel)
        user.image = try? await requestImage(forURL: user.imageUrl)
        
        let context = coreDataService.viewContext
        UserDefaults.standard.userLogin = user.login
        try? UserEntity.findOrCreate(user: user, context: context)
        return user
    }
    
    func requestImage(forURL url: String) async throws -> UIImage {
        let imageData = try await imageLoaderService.getImageData(fromURLString: url)
        guard let image = UIImage(data: imageData) else {
            throw MyImageError.failedToInitialize
        }
        return image
    }
}
