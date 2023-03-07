//
//  PublicApiServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class PublicApiServiceTests: XCTestCase {
    
    func testGetTitle() async throws {
        let id = "8500"
        do {
            _ = try await PublicApiService.shared.getTitle(with: id)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetTitles() async throws {
        let ids = "8500, 8800"
        do {
            _ = try await PublicApiService.shared.getTitles(with: ids)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetUpdates() async throws {
        let limit = 10
        let after = 1
        do {
            _ = try await PublicApiService.shared.getUpdates(withLimit: limit, after: after)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetChanges() async throws {
        let limit = 10
        do {
            _ = try await PublicApiService.shared.getChanges(with: limit)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetSchedule() async throws {
        do {
            _ = try await PublicApiService.shared.getSchedule(with: DaysOfTheWeek.allCases)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetRandomTitle() async throws {
        do {
            _ = try await PublicApiService.shared.getRandomTitle()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetYouTube() async throws {
        let limit = 10
        let after = 1
        do {
            _ = try await PublicApiService.shared.getYouTube(withLimit: limit, after: after)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetYears() async throws {
        do {
            _ = try await PublicApiService.shared.getYears()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetGenres() async throws {
        do {
            _ = try await PublicApiService.shared.getGenres()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetTeam() async throws {
        do {
            _ = try await PublicApiService.shared.getTeam()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetCachingNodes() async throws {
        do {
            _ = try await PublicApiService.shared.getCachingNodes()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testSearchTitles() async throws {
        do {
            _ = try await PublicApiService.shared.searchTitles(withSearch: "Песнь")
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
}
