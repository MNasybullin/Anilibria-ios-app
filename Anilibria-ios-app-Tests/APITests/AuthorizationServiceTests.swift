//
//  AuthorizationServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class AuthorizationServiceTests: XCTestCase {
    var authorizationService: AuthorizationService!
    let networkMonitor = NetworkMonitor.shared
    let errorProcessing = ErrorProcessing.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        authorizationService = AuthorizationService()
    }
    
    override func tearDownWithError() throws {
        authorizationService = nil
        try super.tearDownWithError()
    }
    
    func testLogin() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let email = "anilibria_test@mail.ru"
        let password = "TestPasswordTest"
        
        do {
            _ = try await authorizationService.login(email: email, password: password)
            UserDefaults.standard.isUserAuthorized = true
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
    
    func testLogout() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            try await authorizationService.logout()
            UserDefaults.standard.isUserAuthorized = false
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
    
    func testGetUserFavorites() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            try await testLogin()
            _ = try await authorizationService.getUserFavorites()
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
    
    func testDelUserFavorite() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let titleID = 8500
        do {
            try await testLogin()
            _ = try await authorizationService.delUserFavorite(from: titleID)
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
    
    func testPutUserFavorite() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let titleID = 8500
        do {
            try await testLogin()
            try await testDelUserFavorite()
            _ = try await authorizationService.putUserFavorites(from: titleID)
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
    
    func testUser() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            try await testLogin()
            _ = try await authorizationService.user()
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
}
