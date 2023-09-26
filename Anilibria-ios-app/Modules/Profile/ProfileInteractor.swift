//
//  ProfileInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import UIKit

protocol ProfileInteractorProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol! { get set }
    
    func authorization(email: String, password: String) async throws -> LoginModel
    func requestProfileInfo() async throws -> ProfileModel
    func requestImage(forURL url: String) async throws -> UIImage 
}

final class ProfileInteractor: ProfileInteractorProtocol {
    weak var presenter: ProfilePresenterProtocol!
    
    func authorization(email: String, password: String) async throws -> LoginModel {
        do {
            let user = try await AuthorizationService.shared.login(email: email, password: password)
            // TODO - обработать ошибки
            return user
        } catch {
            throw error
        }
    }
    
    func requestProfileInfo() async throws -> ProfileModel {
        do {
            let userInfo = try await AuthorizationService.shared.profileInfo()
            // TODO - обработать ошибки
            return userInfo
        } catch {
            throw error
        }
    }
    
    func requestImage(forURL url: String) async throws -> UIImage {
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: url)
            guard let image = UIImage(data: imageData) else {
                throw MyImageError.failedToInitialize
            }
            // TODO - обработать ошибки
            return image
        } catch {
            throw error
        }
    }
}
