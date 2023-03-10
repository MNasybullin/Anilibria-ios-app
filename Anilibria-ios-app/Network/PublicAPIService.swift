//
//  PublicApiService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

final class PublicApiService: QueryService {
    // MARK: - Singleton
    static let shared: PublicApiService = PublicApiService()
    
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
    /// - Parameters:
    ///     - sortingType: Тип сортировки элементов.
    ///     0 - Сортировка по алфавиту
    ///     1 - Сортировка по рейтингу
    ///     (По умолчанию 0)
    func getGenres(sortingType: Int = 0) async throws -> [String] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getGenres)
        urlComponents?.queryItems = [
            URLQueryItem(name: "sorting_type", value: String(sortingType))
        ]
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([String].self, from: data)
        return decoded
    }
    
    /// Возвращает список участников команды когда-либо существовавших на проекте.
    func getTeam() async throws -> GetTeamModel {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getTeam)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode(GetTeamModel.self, from: data)
        return decoded
    }
    
    /// Получить список кеш серверов с которых можно брать данные отсортированные по нагрузке. Севера сортируются в реальном времени, по этому рекомендуется для каждого сервера использовать один из самых верхних серверов.
    func getCachingNodes() async throws -> [String] {
        let urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.getCachingNodes)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([String].self, from: data)
        return decoded
    }
    
    /// Возвращает список найденных по фильтрам тайтлов
    /// - Parameters:
    ///     - withSearch: Поиск по именам и описанию
    ///     - year: Список годов выхода (Пример: 2004,2005)
    ///     - season_code: Список сезонов (1 - Зима, 2 - Весна, 3 - Лето, 4 - Осень) (Пример: 1,2)
    ///     - genres: Список жанров (Пример: комедия,музыка)
    ///     - withLimit: Количество роликов запрашиваемые у сервера. (По умолчанию 10)
    ///     - after: Удаляет первые n записей из выдачи (По умолчанию 0)
    func searchTitles(withSearch search: String = "",
                      year: String = "",
                      seasonCode: String = "",
                      genres: String = "",
                      withLimit limit: Int = 10,
                      after: Int = 0) async throws -> [GetTitleModel] {
        var urlComponents = URLComponents(string: Strings.NetworkConstants.apiAnilibriaURL + Strings.NetworkConstants.searchTitles)
        urlComponents?.queryItems = [
            URLQueryItem(name: "search", value: search),
            URLQueryItem(name: "year", value: year),
            URLQueryItem(name: "season_code", value: seasonCode),
            URLQueryItem(name: "genres", value: genres),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "after", value: String(after)),
            URLQueryItem(name: "playlist_type", value: "array")
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try JSONDecoder().decode([GetTitleModel].self, from: data)
        return decoded
    }
}
