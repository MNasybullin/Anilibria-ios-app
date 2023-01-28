//
//  QueryService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.07.2022.
//

import Foundation
import UIKit

class QueryService {
    
    // MARK: - Singleton
    static let shared: QueryService = QueryService()
    
    private enum HttpMethods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case del = "DELETE"
    }
    
    private func errorHandling(for response: URLResponse) -> MyNetworkError {
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
    
    private func dataRequest(with urlComponents: URLComponents?, httpMethod: HttpMethods) async throws -> Data {
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
    
    // MARK: - Internal Methods | API Public Methods
    
    /// Получить информацию о тайтле по id
    /// - Parameters:
    ///     - with id: ID тайтла
    func getTitle(with id: String) async throws -> GetTitleModel {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getTitle)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode(GetTitleModel.self, from: data)
        return decoded
    }
    
    /// Получить информацию о нескольких тайтлах сразу по id
    /// - Parameters:
    ///     - with ids: IDs тайтлов через запятую. Пример ("8500,8644")
    func getTitles(with ids: String) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getTitles)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id_list", value: ids),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Получить список тайтлов отсортированный по времени добавления нового релиза
    /// - Parameters:
    ///     - withlimit: Количество запрашиваемых объектов (По умолчанию 14)
    ///     - after: Удаляет первые n записей из выдачи (По умолчанию 0)
    func getUpdates(withLimit limit: Int = 14, after: Int = 0) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getUpdates)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "playlist_type", value: "array"),
            URLQueryItem(name: "after", value: String(after))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Получить список тайтлов отсортированный по времени изменения
    /// - Parameters:
    ///     - withlimit: Количество запрашиваемых объектов
    func getChanges(with limit: Int = 5) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getChanges)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Получить  расписание выхода тайтлов, отсортированное по дням недели
    /// - Parameters:
    ///     - withdays: Список дней недели на которые нужно расписание
    func getSchedule(with days: [DaysOfTheWeek]) async throws -> [GetScheduleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getSchedule)
        let daysString = days.reduce("", {$0 + String($1.rawValue) + ","})
        urlComponents?.queryItems = [
            URLQueryItem(name: "days", value: daysString),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetScheduleModel].self, from: data)
        return decoded
    }
    
    /// Получить случайный тайтл из базы
    func getRandomTitle() async throws -> GetTitleModel {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getRandomTitle)
        urlComponents?.queryItems = [
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode(GetTitleModel.self, from: data)
        return decoded
    }
    
    /// Получить информацию о вышедших роликах на наших YouTube каналах в хронологическом порядке.
    /// - Parameters:
    ///     - withlimit: Количество роликов запрашиваемые у сервера. (По умолчанию 5)
    ///     - after: Удаляет первые n записей из выдачи (По умолчанию 0)
    func getYouTube(withLimit limit: Int = 5, after: Int = 0) async throws -> [GetYouTubeModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getYouTube)
        urlComponents?.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "after", value: String(after))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetYouTubeModel].self, from: data)
        return decoded
    }
    
    /// Получить список годов выхода доступных тайтлов отсортированный по возрастанию
    func getYears() async throws -> [Int] {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getYears)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([Int].self, from: data)
        return decoded
    }
    
    /// Получить список жанров доступных тайтлов отсортированный по алфавиту
    func getGenres() async throws -> [String] {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getGenres)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([String].self, from: data)
        return decoded
    }
    
    /// Получить список кеш серверов с которых можно брать данные отсортированные по нагрузке. Севера сортируются в реальном времени, по этому рекомендуется для каждого сервера использовать один из самых верхних серверов.
    func getCachingNodes() async throws -> [String] {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getCachingNodes)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([String].self, from: data)
        return decoded
    }
    
    // MARK: - Internal Methods | Custom Methods Requiring Authorization
    
    /// Авторизация
    func login(email: String, password: String) async throws -> LoginModel {
        guard let url = URL(string: Strings.NetworkConstants.mirrorAnilibriaURL + Strings.NetworkConstants.login) else {
            throw MyNetworkError.invalidURLComponents
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        var body = URLComponents()
        body.queryItems = [
            URLQueryItem(name: "mail", value: email),
            URLQueryItem(name: "passwd", value: password)
        ]
        urlRequest.httpBody = body.query?.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        let decoded = try JSONDecoder().decode(LoginModel.self, from: data)
        if decoded.key == KeyLogin.success.rawValue {
            UserDefaults.standard.setSessionId(decoded.sessionId)
        }
        return decoded
    }
    
    /// Выход
    func logout() async throws {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.mirrorAnilibriaURL + Strings.NetworkConstants.logout)
        _ = try await dataRequest(with: urlComponents, httpMethod: .post)
    }

    /// Получить список избранных тайтлов пользователя
    func getFavorites() async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getFavorites)
        guard let sessionId = UserDefaults.standard.getSessionId() else {
            throw MyNetworkError.userIsNotAuthorized
        }
        urlComponents?.queryItems = [
            URLQueryItem(name: "session", value: sessionId),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
    
    /// Добавить тайтл в список избранных
    func addFavorite(from titleId: Int) async throws {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.addFavorite)
        guard let sessionId = UserDefaults.standard.getSessionId() else {
            throw MyNetworkError.userIsNotAuthorized
        }
        urlComponents?.queryItems = [
            URLQueryItem(name: "session", value: sessionId),
            URLQueryItem(name: "title_id", value: String(titleId))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .put)
        let decoded = try JSONDecoder().decode(FavoriteModel.self, from: data)
        guard let error = decoded.error else {
            return
        }
        throw error as Error
    }
    
    /// Удалить тайтл из списка избранных
    func delFavorite(from titleId: Int) async throws {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.delFavorite)
        guard let sessionId = UserDefaults.standard.getSessionId() else {
            throw MyNetworkError.userIsNotAuthorized
        }
        urlComponents?.queryItems = [
            URLQueryItem(name: "session", value: sessionId),
            URLQueryItem(name: "title_id", value: String(titleId))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .del)
        let decoded = try JSONDecoder().decode(FavoriteModel.self, from: data)
        guard let error = decoded.error else {
            return
        }
        throw error as Error
    }
    
    /// Получить информацию о пользователе
    func profileInfo() async throws -> ProfileModel {
        guard let url = URL(string: Strings.NetworkConstants.mirrorAnilibriaURL + Strings.NetworkConstants.profile) else {
            throw MyNetworkError.invalidURLComponents
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HttpMethods.post.rawValue
        var body = URLComponents()
        body.queryItems = [
            URLQueryItem(name: "query", value: "user")
        ]
        urlRequest.httpBody = body.query?.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 /* OK */ else {
            throw errorHandling(for: response)
        }
        let decoded = try JSONDecoder().decode(ProfileModel.self, from: data)
        guard let error = decoded.error else {
            return decoded
        }
        throw error as Error
    }
    
    // MARK: - Download Methods
        
    func getImageData(from urlSuffix: String) async throws -> Data {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.mirrorBaseImagesURL + urlSuffix)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        return data
    }
}
