//
//  QueryService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.07.2022.
//

import Foundation

class QueryService {
    // MARK: - Internal Methods
    
    /// Информация о вышедших роликах на наших YouTube каналах в хронологическом порядке.
    /// - Parameters:
    /// - withLimit - Количество роликов запрашиваемые у сервера. По умолчанию = 5.
    func getYouTube(withLimit value: String = "5") async throws -> [GetYouTubeModel] {
        var urlComponents = URLComponents(string: NetworkConstants.baseAnilibriaURL + "/v2/getYouTube")
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: value)
        ]
        
        guard let url = urlComponents?.url else {
            throw MyNetworkingError.invalidURLComponents
        }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw MyNetworkingError.invalidServerResponse
        }
        
        let decoded = try JSONDecoder().decode([GetYouTubeModel].self, from: data)
        return decoded
    }
}
