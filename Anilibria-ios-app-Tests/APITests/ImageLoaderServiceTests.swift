//
//  ImageLoaderServiceTests.swift
//  Anilibria-ios-appTests
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import XCTest
@testable import Anilibria_ios_app

class ImageLoaderServiceTests: XCTestCase {
    let networkMonitor = NetworkMonitor.shared
    let errorProcessing = ErrorProcessing.shared
    
    func testGetImage() async throws {
        try XCTSkipUnless(networkMonitor.isConnected, "Network connectivity needed for this test.")
        
        let urlString = NetworkConstants.mirrorBaseImagesURL + "/upload/avatars/noavatar.jpg"
        do {
            _ = try await ImageLoaderService.shared.getImageData(fromURLString: urlString)
        } catch {
            XCTFail(errorProcessing.getMessageFrom(error: error))
        }
    }
}
