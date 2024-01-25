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
    
    func testTitle() async throws {
        let id = "8500"
        do {
            _ = try await publicApiService.title(id: id)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTitleList() async throws {
        let ids = "8500, 8800"
        do {
            _ = try await publicApiService.titleList(ids: ids)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTitleUpdates() async throws {
        let limit = 10
        do {
            _ = try await publicApiService.titleUpdates(page: 1, itemsPerPage: limit)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTitleChanges() async throws {
        let limit = 10
        do {
            _ = try await publicApiService.titleChanges(page: 1, itemsPerPage: limit)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTitleSchedule() async throws {
        do {
            _ = try await publicApiService.titleSchedule(withDays: DaysOfTheWeek.allCases)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTitleRandom() async throws {
        do {
            _ = try await publicApiService.titleRandom()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testYouTube() async throws {
        let limit = 10
        do {
            _ = try await publicApiService.youTube(page: 1, itemsPerPage: limit)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testYears() async throws {
        do {
            _ = try await publicApiService.years()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testGenres() async throws {
        do {
            _ = try await publicApiService.genres()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTeam() async throws {
        do {
            _ = try await publicApiService.team()
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
    
    func testTitleSearch() async throws {
        do {
            _ = try await publicApiService.titleSearch(withSearchText: "Песнь", page: 1)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
}
