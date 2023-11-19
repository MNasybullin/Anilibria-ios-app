//
//  PublicApiServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class PublicApiServiceTests: XCTestCase {
    
    let publicApiService = PublicApiService()
    
    func testGetTitle() async throws {
        let id = "8500"
        do {
            _ = try await publicApiService.getTitle(with: id)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetTitles() async throws {
        let ids = "8500, 8800"
        do {
            _ = try await publicApiService.getTitles(with: ids)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetUpdates() async throws {
        let limit = 10
        let after = 1
        do {
            _ = try await publicApiService.getUpdates(withLimit: limit, after: after)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetChanges() async throws {
        let limit = 10
        do {
            _ = try await publicApiService.getChanges(with: limit)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetSchedule() async throws {
        do {
            _ = try await publicApiService.getSchedule(with: DaysOfTheWeek.allCases)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetRandomTitle() async throws {
        do {
            _ = try await publicApiService.getRandomTitle()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetYouTube() async throws {
        let limit = 10
        let after = 1
        do {
            _ = try await publicApiService.getYouTube(withLimit: limit, after: after)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetYears() async throws {
        do {
            _ = try await publicApiService.getYears()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetGenres() async throws {
        do {
            _ = try await publicApiService.getGenres()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetTeam() async throws {
        do {
            _ = try await publicApiService.getTeam()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGetCachingNodes() async throws {
        do {
            _ = try await publicApiService.getCachingNodes()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testSearchTitles() async throws {
        do {
            _ = try await publicApiService.searchTitles(withSearchText: "Песнь")
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
}
