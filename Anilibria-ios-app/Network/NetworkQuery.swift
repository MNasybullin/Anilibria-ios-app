//
//  NetworkQuery.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.07.2022.
//

import Foundation

class NetworkQuery {
    enum HTTPMethods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case del = "DELETE"
    }
    
    lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
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
    
    func dataRequest(with urlComponents: URLComponents?,
                     httpMethod: HTTPMethods) async throws -> Data {
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
