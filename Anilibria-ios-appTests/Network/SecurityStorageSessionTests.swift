//
//  SecurityStorageSessionTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.10.2023.
//

import XCTest
@testable import Anilibria_ios_app

final class SecurityStorageSessionTests: XCTestCase {
    
    let account = "SessionTests"
    let securityStorage = SecurityStorage()
    
    override func tearDownWithError() throws {
        try? securityStorage.deleteSession(withAccount: account)
    }
    
    func testAddSession() {
        let session = "TestAddSession"
        
        XCTAssertNoThrow(try securityStorage.addSession(session, withAccount: account))
    }
    
    func testUpdateSession() {
        let session = "TestUpdateSession"
        
        XCTAssertThrowsError(try securityStorage.updateSession(session, withAccount: account))
        
        testAddSession()
        
        XCTAssertNoThrow(try securityStorage.updateSession(session, withAccount: account))
    }
    
    func testGetSession() {
        XCTAssertThrowsError(try securityStorage.getSession(withAccount: account))
        
        testAddSession()
        
        XCTAssertNoThrow(try securityStorage.getSession(withAccount: account))
    }
    
    func testDeleteSession() {
        XCTAssertThrowsError(try securityStorage.deleteSession(withAccount: account))
        
        testAddSession()
        
        XCTAssertNoThrow(try securityStorage.deleteSession(withAccount: account))
    }
}
