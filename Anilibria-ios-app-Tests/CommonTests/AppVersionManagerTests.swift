//
//  AppVersionManagerTests.swift
//  APITests
//
//  Created by Mansur Nasybullin on 10.04.2024.
//

import XCTest
@testable import Anilibria_ios_app

final class AppVersionManagerTests: XCTestCase {
    var appVersionManager = AppVersionManager()
    
    func testCurrentVersionIsLessThan() {
        XCTAssertTrue(appVersionManager.currentVersionIsLessThan(version: "510.1.2"))
        
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "0"))
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "a"))
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "0.0.0"))
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "0.0.5"))
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "0.1.5a"))
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "0.1.a"))
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: "a.0.a"))
        
        XCTAssertFalse(appVersionManager.currentVersionIsLessThan(version: ""))
    }

}
