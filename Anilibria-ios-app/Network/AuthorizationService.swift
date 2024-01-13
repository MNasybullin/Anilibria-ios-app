//
//  AuthorizationService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

final class AuthorizationService: NetworkQuery {    
    typealias KeychainError = SecurityStorage.KeychainError
    typealias Credentials = SecurityStorage.Credentials
    
    private let securityStorage = SecurityStorage()
    
    /// Авторизация
    func login(email: String, password: String) async throws -> LoginAPIModel {
        guard let url = URL(string: NetworkConstants.mirrorAnilibriaURL + NetworkConstants.login) else {
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
        
        let decoded = try jsonDecoder.decode(LoginAPIModel.self, from: data)
        if decoded.key == KeyLoginAPI.success.rawValue,
            let sessionId = decoded.sessionId {
            try securityStorage.addOrUpdateSession(sessionId)
            
            let credentials = Credentials(login: email, password: password)
            try securityStorage.addOrUpdateCredentials(credentials)
        }
        return decoded
    }
    
    // Тихая авторизация
    func relogin() async throws -> LoginAPIModel {
        let credentials = try securityStorage.getCredentials()
        
        return try await login(email: credentials.login, password: credentials.password)
    }
    
    /// Выход
    func logout() async throws {
        let urlComponents = URLComponents(string: NetworkConstants.mirrorAnilibriaURL + NetworkConstants.logout)
        _ = try await dataRequest(with: urlComponents, httpMethod: .post)
        
        try securityStorage.deleteSession()
        try securityStorage.deleteCredentials()
    }
    
    /// Получить список избранных тайтлов пользователя
    /// - Parameters:
    ///     - withlimit: Количество запрашиваемых объектов (По умолчанию -1 (Все))
    func getFavorites(withLimit limit: Int = -1) async throws -> [TitleAPIModel] {
        if UserDefaults.standard.isUserAuthorized == false {
            throw MyInternalError.userIsNotFoundInUserDefaults
        }
        let sessionId = try securityStorage.getSession()
        
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.getFavorites)
        urlComponents?.queryItems = [
            URLQueryItem(name: "session", value: sessionId),
            URLQueryItem(name: "playlist_type", value: "array"),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode([TitleAPIModel].self, from: data)
        return decoded
    }
    
    /// Добавить тайтл в список избранных
    func addFavorite(from titleId: Int) async throws {
        if UserDefaults.standard.isUserAuthorized == false {
            throw MyInternalError.userIsNotFoundInUserDefaults
        }
        let sessionId = try securityStorage.getSession()
        
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.addFavorite)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "session", value: sessionId),
            URLQueryItem(name: "title_id", value: String(titleId))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .put)
        let decoded = try jsonDecoder.decode(FavoriteAPIModel.self, from: data)
        guard let error = decoded.error else {
            return
        }
        throw error as Error
    }
    
    /// Удалить тайтл из списка избранных
    func delFavorite(from titleId: Int) async throws {
        if UserDefaults.standard.isUserAuthorized == false {
            throw MyInternalError.userIsNotFoundInUserDefaults
        }
        
        let sessionId = try securityStorage.getSession()
        
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.delFavorite)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "session", value: sessionId),
            URLQueryItem(name: "title_id", value: String(titleId))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .del)
        let decoded = try jsonDecoder.decode(FavoriteAPIModel.self, from: data)
        guard let error = decoded.error else {
            return
        }
        throw error as Error
    }
    
    /// Получить информацию о пользователе
    func profileInfo() async throws -> ProfileAPIModel {
        guard let url = URL(string: NetworkConstants.mirrorAnilibriaURL + NetworkConstants.profile) else {
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
        let decoded = try jsonDecoder.decode(ProfileAPIModel.self, from: data)
        guard let error = decoded.error else {
            return decoded
        }
        throw error as Error
    }
}
