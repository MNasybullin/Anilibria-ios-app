//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by Mansur Nasybullin on 09.08.2022.
//

import XCTest
import Network
@testable import Anilibria_ios_app

class NetworkPublicApiTests: XCTestCase {

    func testGetTitle() async throws {
        let id = "8500"
        do {
            _ = try await QueryService.shared.getTitle(with: id)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetTitles() async throws {
        let ids = "8500, 8800"
        do {
            _ = try await QueryService.shared.getTitles(with: ids)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetUpdates() async throws {
        let limit = 10
        do {
            _ = try await QueryService.shared.getUpdates(with: limit)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetChanges() async throws {
        let limit = 10
        do {
            _ = try await QueryService.shared.getChanges(with: limit)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
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
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetRandomTitle() async throws {
        do {
            _ = try await QueryService.shared.getRandomTitle()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetYouTube() async throws {
        let limit = 10
        do {
            _ = try await QueryService.shared.getYouTube(with: limit)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetYears() async throws {
        do {
            _ = try await QueryService.shared.getYears()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetGenres() async throws {
        do {
            _ = try await QueryService.shared.getGenres()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetCachingNodes() async throws {
        do {
            _ = try await QueryService.shared.getCachingNodes()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetImage() async throws {
        let urlSuffix = "/upload/avatars/noavatar.jpg"
        do {
            _ = try await QueryService.shared.getImage(from: urlSuffix)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

class NetworkAPIRequiringAuthorizationTests: XCTestCase {
    
    func testLogin() async throws {
        let email = "anilibria_test@mail.ru"
        let password = "TestPasswordTest"
        
        do {
            _ = try await QueryService.shared.login(email: email, password: password)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLogout() async throws {
        do {
            try await QueryService.shared.logout()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testGetFavorite() async throws {
        do {
            try await testLogin()
            _ = try await QueryService.shared.getFavorites()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDelFavorite() async throws {
        let titleID = 8500
        do {
            try await testLogin()
            _ = try await QueryService.shared.delFavorite(from: titleID)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testAddFavorite() async throws {
        let titleID = 8500
        do {
            try await testLogin()
            try await testDelFavorite()
            _ = try await QueryService.shared.addFavorite(from: titleID)
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testProfileInfo() async throws {
        do {
            try await testLogin()
            _ = try await QueryService.shared.profileInfo()
        } catch let error as MyNetworkError {
            XCTFail(error.description)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
