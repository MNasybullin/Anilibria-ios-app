//
//  CacheTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 07.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class CacheTests: XCTestCase {
    
    let key = "Test Key"
    let value = "Test Value"
    
    func configureStringCache(withLifetime lifetime: TimeInterval = 12 * 60 * 60) -> Cache<String, String> {
        let stringCache = Cache<String, String>(entryLifetime: lifetime)
        
        stringCache[key] = value
        return stringCache
    }
    
    func testInsertAndRead() {
        let stringCache = configureStringCache()
        XCTAssertNotNil(stringCache[key])
        XCTAssertEqual(stringCache[key], value)
    }
    
    func testRemoveValue() {
        let stringCache = configureStringCache()
        stringCache[key] = nil
        XCTAssertNil(stringCache[key])
    }
    
    func testExpirationValue() {
        let lifetime: TimeInterval = 3
        let stringCache = configureStringCache(withLifetime: lifetime)
        
        XCTAssertNotNil(stringCache[key])
        XCTAssertEqual(stringCache[key], value)
        
        sleep(UInt32(lifetime))
        XCTAssertNil(stringCache[key])
    }
}
