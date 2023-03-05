//
//  ImageLoaderServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class ImageLoaderServiceTests: XCTestCase {
    func testGetImage() async throws {
        let urlSuffix = "/upload/avatars/noavatar.jpg"
        do {
            _ = try await ImageLoaderService.shared.getImageData(from: urlSuffix)
        } catch {
            let message = ErrorProcessing.shared.getMessageFrom(error: error)
            XCTFail(message)
        }
    }
}
