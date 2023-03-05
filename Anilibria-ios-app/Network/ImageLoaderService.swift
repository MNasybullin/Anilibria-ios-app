//
//  ImageLoaderService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

class ImageLoaderService: QueryService {
    // MARK: - Singleton
    static let shared: ImageLoaderService = ImageLoaderService()
    
    // TODO: добавить кэширование изображений
    func getImageData(from urlSuffix: String) async throws -> Data {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.mirrorBaseImagesURL + urlSuffix)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        return data
    }
}
