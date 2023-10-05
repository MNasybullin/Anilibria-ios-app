//
//  AuthorizationService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

final class AuthorizationService: QueryProtocol {
    // MARK: - Singleton
    static let shared: AuthorizationService = AuthorizationService()
    private init() { }
    
    private let securityStorage = SecurityStorage()
    
    private lazy var credentials: SecurityStorage.Credentials? = try? securityStorage.getCredentials() {
        didSet {
            if credentials != nil {
                try? securityStorage.addCredentials(credentials!)
            } else {
                try? securityStorage.deleteCredentials()
            }
        }
    }
    
    private lazy var sessionId: String? = try? securityStorage.getSession() {
        didSet {
            if sessionId != nil {
                try? securityStorage.addSession(sessionId!)
            } else {
                try? securityStorage.deleteSession()
            }
        }
    }
    
    /// Авторизация
    func login(email: String, password: String) async throws -> LoginModel {
        guard let url = URL(string: Strings.NetworkConstants.mirrorAnilibriaURL + Strings.NetworkConstants.login) else {
            throw MyNetworkError.invalidURLComponents
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.post.rawValue
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
        if decoded.key == KeyLogin.success.rawValue, let sessionId = decoded.sessionId {
            self.sessionId = sessionId
            self.credentials = SecurityStorage.Credentials(login: email, password: password)
        }
        return decoded
    }
    
    // Тихая авторизация
    func relogin() async throws -> LoginModel {
        guard let credentials = credentials else {
            throw MyNetworkError.userIsNotAuthorized
        }
        return try await login(email: credentials.login, password: credentials.password)
    }
    
    /// Выход
    func logout() async throws {
        self.sessionId = nil
        self.credentials = nil
        
        let urlComponents = URLComponents(string: Strings.NetworkConstants.mirrorAnilibriaURL + Strings.NetworkConstants.logout)
        _ = try await dataRequest(with: urlComponents, httpMethod: .post)
    }

    /// Получить список избранных тайтлов пользователя
    func getFavorites() async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getFavorites)
        guard let sessionId = sessionId else {
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
        guard let sessionId = sessionId else {
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
        guard let sessionId = sessionId else {
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
        urlRequest.httpMethod = HTTPMethods.post.rawValue
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
}
