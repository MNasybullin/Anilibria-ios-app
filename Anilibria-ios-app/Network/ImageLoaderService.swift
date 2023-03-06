//
//  ImageLoaderService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

final class ImageLoaderService: QueryService {
    // MARK: - Singleton
    static let shared: ImageLoaderService = ImageLoaderService()
    
    private let cache = NSCache <NSString, NSData>()
    
    func getImageData(from urlSuffix: String) async throws -> Data {
        if let cachedData = cache.object(forKey: urlSuffix as NSString) {
            return cachedData as Data
        }
        let urlComponents = URLComponents(string: Strings.NetworkConstants.mirrorBaseImagesURL + urlSuffix)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        cache.setObject(data as NSData, forKey: urlSuffix as NSString)
        return data
    }
}
