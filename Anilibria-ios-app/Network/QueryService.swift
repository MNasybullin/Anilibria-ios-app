//
//  QueryService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.07.2022.
//

import Foundation
import UIKit

class QueryService {
    
    enum HttpMethods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case del = "DELETE"
    }
    
    func errorHandling(for response: URLResponse) -> MyNetworkError {
        guard let httpResonse = response as? HTTPURLResponse else {
            return MyNetworkError.invalidServerResponse
        }
        switch httpResonse.statusCode {
            case 500:
                return MyNetworkError.internalServerError
            case 412:
                return MyNetworkError.unknownParameters
            case 404:
                return MyNetworkError.notFound
            default:
                return MyNetworkError.unknown
        }
    }
    
    func dataRequest(with urlComponents: URLComponents?, httpMethod: HttpMethods) async throws -> Data {
        guard let url = urlComponents?.url else {
            throw MyNetworkError.invalidURLComponents
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        return data
    }
}
