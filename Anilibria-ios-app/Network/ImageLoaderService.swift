//
//  ImageLoaderService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

final class ImageLoaderService {
    // MARK: - Singleton
    static let shared: ImageLoaderService = ImageLoaderService()
    
    private let mByte = 1024 * 1024
        
    private lazy var urlCache: URLCache = {
        let urlCache = URLCache(memoryCapacity: 50 * mByte, diskCapacity: 50 * mByte, diskPath: "images")
        return urlCache
    }()
    
    private lazy var session: URLSession = {
        let configure = URLSessionConfiguration.default
        configure.urlCache = urlCache
        configure.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: configure)
    }()
    
    func getImageData(from urlSuffix: String) async throws -> Data {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.mirrorBaseImagesURL + urlSuffix)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        return data
    }
    
}

extension ImageLoaderService: QueryProtocol {
    func dataRequest(with urlComponents: URLComponents?, httpMethod: HTTPMethods) async throws -> Data {
        guard let url = urlComponents?.url else {
            throw MyNetworkError.invalidURLComponents
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.cachePolicy = .useProtocolCachePolicy

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        return data
    }
}
