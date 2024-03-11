//
//  PublicApiServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class PublicApiServiceTests: XCTestCase {
    var publicApiService: PublicApiService!
    let networkMonitor = NetworkMonitor.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        publicApiService = PublicApiService()
    }
    
    override func tearDownWithError() throws {
        publicApiService = nil
        try super.tearDownWithError()
    }
    
    func testTitle() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let id = "8500"
        do {
            _ = try await publicApiService.title(id: id)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleList() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let ids = "8500, 8800"
        do {
            _ = try await publicApiService.titleList(ids: ids)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleUpdates() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let limit = 10
        do {
            _ = try await publicApiService.titleUpdates(page: 1, itemsPerPage: limit)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleChanges() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let limit = 10
        do {
            _ = try await publicApiService.titleChanges(page: 1, itemsPerPage: limit)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleSchedule() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.titleSchedule(withDays: DaysOfTheWeek.allCases)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleRandom() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.titleRandom()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testYouTube() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let limit = 10
        do {
            _ = try await publicApiService.youTube(page: 1, itemsPerPage: limit)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testYears() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.years()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGenres() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.genres()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTeam() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.team()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleSearch() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.titleSearch(withSearchText: "Песнь", page: 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleFranchises() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.titleFranchises(id: 8500)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFranchiseList() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        do {
            _ = try await publicApiService.franchiseList(page: 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
