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
    
    weak var delegate: UserModelDelegate?
    
    func authorization(email: String, password: String) {
        Task(priority: .userInitiated) {
            do {
                let loginModel = try await authorizationService.login(email: email, password: password)
                
                if loginModel.key == KeyLoginAPI.success.rawValue {
                    let user = try await requestProfileInfo()
                    delegate?.authorizationSuccessful(user: user)
                } else if loginModel.key == KeyLoginAPI.authorized.rawValue {
                    // Уже авторизован, Идет перелогин...
                    try? await authorizationService.logout()
                    authorization(email: email, password: password)
                } else {
                    let error = NSError(domain: loginModel.key, code: 0)
                    delegate?.authorizationFailure(error: error)
                }
            } catch {
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
            delegate?.requestFromCoreDataFailure(error: error)
        }
    }
    
    func logout() {
        Task(priority: .userInitiated) {
            do {
                try await authorizationService.logout()
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
        let context = CoreDataService.shared.viewContext
        let userEntity = try UserEntity.get(context: context)
        let user = UserItem(userEntity: userEntity)
        return user
    }
    
    func requestProfileInfo() async throws -> UserItem {
        let profileInfo = try await authorizationService.profileInfo()
        guard let data = profileInfo.data else {
            throw MyNetworkError.userIsNotAuthorized
        }
        let userImage = try await requestImage(forURL: data.avatar)
        
        let user = UserItem(id: data.id, name: data.login, image: userImage, imageUrl: data.avatar)
        
        let context = CoreDataService.shared.viewContext
        try? UserEntity.create(user: user, context: context)
        return user
    }
    
    func requestImage(forURL url: String) async throws -> UIImage {
        let imageData = try await ImageLoaderService.shared.getImageData(from: url)
        guard let image = UIImage(data: imageData) else {
            throw MyImageError.failedToInitialize
        }
        return image
    }
}
