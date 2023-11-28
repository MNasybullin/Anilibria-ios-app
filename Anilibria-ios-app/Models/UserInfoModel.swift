//
//  UserInfoModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class UserInfoModel {
    typealias ResultBlock = Result<UserItem, Error>
    
    private let authorizationService = AuthorizationService()
    
    func getUserInfo(completionHandler: @escaping (ResultBlock) -> Void) {
        if UserDefaults.standard.isUserAuthorized {
            requestUserFromCoreData(completionHandler: completionHandler)
        } else {
            requestProfileInfo(completionHandler: completionHandler)
        }
    }
    
    private func requestUserFromCoreData(completionHandler: @escaping (ResultBlock) -> Void) {
        do {
            let context = CoreDataService.shared.viewContext
            let userEntity = try UserEntity.get(context: context)
            let user = UserItem(userEntity: userEntity)
            completionHandler(.success(user))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    private func requestProfileInfo(completionHandler: @escaping (ResultBlock) -> Void) {
        Task(priority: .userInitiated) {
            do {
                let profileInfo = try await authorizationService.profileInfo()
                guard let data = profileInfo.data else {
                    throw MyNetworkError.userIsNotAuthorized
                }
                let userImage = try await requestImage(forURL: data.avatar)
                
                let user = UserItem(id: data.id, name: data.login, image: userImage, imageUrl: data.avatar)
                
                let context = CoreDataService.shared.viewContext
                try? UserEntity.create(user: user, context: context)
                completionHandler(.success(user))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    private func requestImage(forURL url: String) async throws -> UIImage {
        let imageData = try await ImageLoaderService.shared.getImageData(from: url)
        guard let image = UIImage(data: imageData) else {
            throw MyImageError.failedToInitialize
        }
        return image
    }
}
