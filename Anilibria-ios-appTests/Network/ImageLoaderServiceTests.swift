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
        let urlString = NetworkConstants.mirrorBaseImagesURL + "/upload/avatars/noavatar.jpg"
        do {
            _ = try await ImageLoaderService.shared.getImageData(fromURLString: urlString)
        } catch {
            ErrorProcessing.shared.handle(error: error) { message in
                XCTFail(message)
            }
        }
    }
}
