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
    
    private func dataRequest(with urlComponents: URLComponents?) async throws -> Data {
        guard let url = urlComponents?.url else {
            throw MyNetworkingError.invalidURLComponents()
        }
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        return data
    }
    
    // MARK: - Internal Methods | API Public Methods
    
    /// Получить информацию о тайтле по id
    /// - Parameters:
    ///     - with id: ID тайтла
    /// - Throws: `MyNetworkingError`
    func getTitle(with id: String) async throws -> GetTitleModel {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getTitle)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode(GetTitleModel.self, from: data)
        return decoded
    }
    
    /// Получить информацию о нескольких тайтлах сразу по id
    /// - Parameters:
    ///     - with id: ID тайтлов через запятую. Пример ("8500,8644")
    /// - Throws: `MyNetworkingError`
    func getTitles(with id: String) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getTitles)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id_list", value: id),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Получить список тайтлов отсортированный по времени добавления нового релиза
    /// - Parameters:
    ///     - withlimit: Количество запрашиваемых объектов
    /// - Throws: `MyNetworkingError`
    func getUpdates(with limit: Int = 5) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getUpdates)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Получить список тайтлов отсортированный по времени изменения
    /// - Parameters:
    ///     - withlimit: Количество запрашиваемых объектов
    /// - Throws: `MyNetworkingError`
    func getChanges(with limit: Int = 5) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getChanges)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Получить  расписание выхода тайтлов, отсортированное по дням недели
    /// - Parameters:
    ///     - withdays: Список дней недели на которые нужно расписание
    /// - Throws: `MyNetworkingError`
    func getSchedule(with days: [DaysOfTheWeek]) async throws -> [GetScheduleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getSchedule)
        let daysString = days.reduce("", {$0 + String($1.rawValue) + ","})
        urlComponents?.queryItems = [
            URLQueryItem(name: "days", value: daysString),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode([GetScheduleModel].self, from: data)
        return decoded
    }
    
    /// Возвращает случайный тайтл из базы
    /// - Throws: `MyNetworkingError`
    func getRandomTitle() async throws -> GetTitleModel {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getRandomTitle)
        urlComponents?.queryItems = [
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode(GetTitleModel.self, from: data)
        return decoded
    }
    
    /// Информация о вышедших роликах на наших YouTube каналах в хронологическом порядке.
    /// - Parameters:
    ///     - withlimit: Количество роликов запрашиваемые у сервера.
    /// - Throws: `MyNetworkingError`
    func getYouTube(with limit: Int = 5) async throws -> [GetYouTubeModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.baseAnilibriaURL + Strings.NetworkConstants.getYouTube)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        let data = try await dataRequest(with: urlComponents)
        let decoded = try JSONDecoder().decode([GetYouTubeModel].self, from: data)
        return decoded
    }
    
    // MARK: - Internal Methods | Custom Methods Requiring Authorization
}
