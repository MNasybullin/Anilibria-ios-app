//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Mansur Nasybullin on 09.08.2022.
//

import XCTest
@testable import Anilibria_ios_app

class NetworkPublicApiTests: XCTestCase {

    func testGetTitle() async throws {
        let id = "8500"
        do {
            _ = try await QueryService.shared.getTitle(with: id)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetTitles() async throws {
        let ids = "8500, 8800"
        do {
            _ = try await QueryService.shared.getTitles(with: ids)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetUpdates() async throws {
        let limit = 10
        let after = 1
        do {
            _ = try await QueryService.shared.getUpdates(withLimit: limit, after: after)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetChanges() async throws {
        let limit = 10
        do {
            _ = try await QueryService.shared.getChanges(with: limit)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetSchedule() async throws {
        do {
            _ = try await QueryService.shared.getSchedule(with: [.monday,
                .tuesday,
                .wednesday,
                .thursday,
                .friday,
                .saturday,
                .sunday])
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetRandomTitle() async throws {
        do {
            _ = try await QueryService.shared.getRandomTitle()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetYouTube() async throws {
        let limit = 10
        let after = 1
        do {
            _ = try await QueryService.shared.getYouTube(withLimit: limit, after: after)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetYears() async throws {
        do {
            _ = try await QueryService.shared.getYears()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetGenres() async throws {
        do {
            _ = try await QueryService.shared.getGenres()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetTeam() async throws {
        do {
            _ = try await QueryService.shared.getTeam()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetCachingNodes() async throws {
        do {
            _ = try await QueryService.shared.getCachingNodes()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testSearchTitles() async throws {
        do {
            _ = try await QueryService.shared.searchTitles(withSearch: "Песнь")
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetImage() async throws {
        let urlSuffix = "/upload/avatars/noavatar.jpg"
        do {
            _ = try await QueryService.shared.getImageData(from: urlSuffix)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
}

class NetworkAPIRequiringAuthorizationTests: XCTestCase {
    
    func testLogin() async throws {
        let email = "anilibria_test@mail.ru"
        let password = "TestPasswordTest"
        
        do {
            _ = try await QueryService.shared.login(email: email, password: password)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testLogout() async throws {
        do {
            try await QueryService.shared.logout()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testGetFavorite() async throws {
        do {
            try await testLogin()
            _ = try await QueryService.shared.getFavorites()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testDelFavorite() async throws {
        let titleID = 8500
        do {
            try await testLogin()
            _ = try await QueryService.shared.delFavorite(from: titleID)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testAddFavorite() async throws {
        let titleID = 8500
        do {
            try await testLogin()
            try await testDelFavorite()
            _ = try await QueryService.shared.addFavorite(from: titleID)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
    
    func testProfileInfo() async throws {
        do {
            try await testLogin()
            _ = try await QueryService.shared.profileInfo()
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
}
