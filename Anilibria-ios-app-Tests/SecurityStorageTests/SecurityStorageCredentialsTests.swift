//
//  SecurityStorageCredentialsTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.10.2023.
//

import XCTest
@testable import Anilibria_ios_app

final class SecurityStorageCredentialsTests: XCTestCase {
    
    let label = "CredentialsTests"
    let securityStorage = SecurityStorage()
    
    override func tearDownWithError() throws {
        try? securityStorage.deleteCredentials(withLabel: label)
        try super.tearDownWithError()
    }
    
    func testAddCredentials() {
        let login = "TestAddLogin"
        let password = "TestAddPassword"
        let credentials = SecurityStorage.Credentials(login: login, password: password)
        XCTAssertNoThrow(try securityStorage.addCredentials(credentials, withLabel: label))
    }
    
    func testUpdateCredentials() {
        let login = "TestUpdateLogin"
        let password = "TestUpdatePassword"
        let credentials = SecurityStorage.Credentials(login: login, password: password)
        
        XCTAssertThrowsError(try securityStorage.updateCredentials(credentials, withLabel: label))
        
        testAddCredentials()
        
        XCTAssertNoThrow(try securityStorage.updateCredentials(credentials, withLabel: label))
    }
    
    func testGetCredentials() {
        XCTAssertThrowsError(try securityStorage.getCredentials(withLabel: label))
        
        testAddCredentials()
        
        XCTAssertNoThrow(try securityStorage.getCredentials(withLabel: label))
    }
    
    func testDeleteCredentials() {
        XCTAssertThrowsError(try securityStorage.deleteCredentials(withLabel: label))
        
        testAddCredentials()
        
        XCTAssertNoThrow(try securityStorage.deleteCredentials(withLabel: label))
    }
}
