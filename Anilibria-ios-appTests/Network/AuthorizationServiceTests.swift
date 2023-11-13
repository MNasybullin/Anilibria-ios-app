//
//  AuthorizationServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class AuthorizationServiceTests: XCTestCase {
    
    let authorizationService = AuthorizationService()
    
    func testLogin() async throws {
        let email = "anilibria_test@mail.ru"
        let password = "TestPasswordTest"
        
        do {
            _ = try await authorizationService.login(email: email, password: password)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testLogout() async throws {
        do {
            try await authorizationService.logout()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetFavorites() async throws {
        do {
            try await testLogin()
            _ = try await authorizationService.getFavorites()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testDelFavorite() async throws {
        let titleID = 8500
        do {
            try await testLogin()
            _ = try await authorizationService.delFavorite(from: titleID)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testAddFavorite() async throws {
        let titleID = 8500
        do {
            try await testLogin()
            try await testDelFavorite()
            _ = try await authorizationService.addFavorite(from: titleID)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testProfileInfo() async throws {
        do {
            try await testLogin()
            _ = try await authorizationService.profileInfo()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
}
