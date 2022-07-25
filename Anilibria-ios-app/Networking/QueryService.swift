//
//  QueryService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.07.2022.
//

import Foundation

class QueryService {
    // MARK: - Private Methods
    
    private func errorHandling(for response: URLResponse) -> MyNetworkingError {
        guard let httpResonse = response as? HTTPURLResponse else {
            return MyNetworkingError.invalidServerResponse()
        }
        switch httpResonse.statusCode {
            case 500:
                return MyNetworkingError.internalServerError()
            case 412:
                return MyNetworkingError.unknownParameters()
            case 404:
                return MyNetworkingError.notFound()
            default:
                return MyNetworkingError.unknown()
        }
    }
    
    // MARK: - Internal Methods | API Public Methods
    
    /// Информация о вышедших роликах на наших YouTube каналах в хронологическом порядке.
    /// - Parameters:
    ///     - withlimit: Количество роликов запрашиваемые у сервера.
    /// - Throws: `MyNetworkingError`
    func getYouTube(with limit: Int = 5) async throws -> [GetYouTubeModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getYouTube)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = urlComponents?.url else {
            throw MyNetworkingError.invalidURLComponents()
        }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        
        let decoded = try JSONDecoder().decode([GetYouTubeModel].self, from: data)
        return decoded
    }
    
    /// Получить информацию о тайтле по id или коду
    /// - Parameters:
    ///     - with id: ID тайтла
    ///     - code: Код тайтла
    /// - Throws: `MyNetworkingError`
    func getTitle(with id: Int, code: String? = "") async throws -> GetTitleModel {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getTitle)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        guard let url = urlComponents?.url else {
            throw MyNetworkingError.invalidURLComponents()
        }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        print(data)
        let decoded = try JSONDecoder().decode(GetTitleModel.self, from: data)
        return decoded
    }
    
    // MARK: - Internal Methods | Custom Methods Requiring Authorization
}
