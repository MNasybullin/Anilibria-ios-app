//
//  PublicApiService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.03.2023.
//

import Foundation

final class PublicApiService: NetworkQuery {
    
    /// Получить информацию о тайтле по id
    /// - Parameters:
    ///     - id: ID тайтла
    func title(id: String) async throws -> TitleAPIModel {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.title)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "playlist_type", value: "array"),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(TitleAPIModel.self, from: data)
        return decoded
    }
    
    /// Получить информацию о нескольких тайтлах сразу по id
    /// - Parameters:
    ///     - ids: IDs тайтлов через запятую. Пример ("8500,8644")
    func titleList(ids: String) async throws -> [TitleAPIModel] {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.titleList)
        urlComponents?.queryItems = [
            URLQueryItem(name: "id_list", value: ids),
            URLQueryItem(name: "playlist_type", value: "array"),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode([TitleAPIModel].self, from: data)
        return decoded
    }
    
    /// Получить список тайтлов отсортированный по времени добавления нового релиза
    /// - Parameters:
    ///     - page: Номер страницы для запроса
    ///     - itemsPerPage: Количество запрашиваемых объектов на странице (По умолчанию 14)
    func titleUpdates(page: Int,
                      itemsPerPage: Int = 14) async throws -> ListAPIModel<TitleAPIModel> {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.titleUpdates)
        urlComponents?.queryItems = [
            URLQueryItem(name: "playlist_type", value: "array"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage)),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(ListAPIModel<TitleAPIModel>.self, from: data)
        return decoded
    }
    
    /// Получить список тайтлов отсортированный по времени изменения
    /// - Parameters:
    ///     - page: Номер страницы для запроса
    ///     - itemsPerPage: Количество запрашиваемых объектов на странице (По умолчанию 5)
    func titleChanges(page: Int,
                      itemsPerPage: Int = 5) async throws -> ListAPIModel<TitleAPIModel> {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.titleChanges)
        urlComponents?.queryItems = [
            URLQueryItem(name: "playlist_type", value: "array"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage)),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(ListAPIModel<TitleAPIModel>.self, from: data)
        return decoded
    }
    
    /// Получить  расписание выхода тайтлов, отсортированное по дням недели
    /// - Parameters:
    ///     - withDays days: Список дней недели на которые нужно расписание
    func titleSchedule(withDays days: [DaysOfTheWeek]) async throws -> [ScheduleAPIModel] {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.titleSchedule)
        let daysString = days.reduce("", {$0 + String($1.rawValue) + ","})
        urlComponents?.queryItems = [
            URLQueryItem(name: "days", value: daysString),
            URLQueryItem(name: "playlist_type", value: "array"),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode([ScheduleAPIModel].self, from: data)
        return decoded
    }
    
    /// Получить случайный тайтл из базы
    func titleRandom() async throws -> TitleAPIModel {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.titleRandom)
        urlComponents?.queryItems = [
            URLQueryItem(name: "playlist_type", value: "array"),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(TitleAPIModel.self, from: data)
        return decoded
    }
    
    /// Получить информацию о вышедших роликах на наших YouTube каналах в хронологическом порядке.
    /// - Parameters:
    ///     - page: Номер страницы для запроса
    ///     - itemsPerPage: Количество запрашиваемых объектов на странице (По умолчанию 5)
    func youTube(page: Int,
                 itemsPerPage: Int = 5) async throws -> ListAPIModel<YouTubeAPIModel> {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.youtube)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(ListAPIModel<YouTubeAPIModel>.self, from: data)
        return decoded
    }
    
    /// Получить список годов выхода доступных тайтлов отсортированный по возрастанию
    func years() async throws -> [Int] {
        let urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.years)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode([Int].self, from: data)
        return decoded
    }
    
    /// Получить список жанров доступных тайтлов отсортированный по алфавиту
    /// - Parameters:
    ///     - sortingType: Тип сортировки элементов.
    ///     0 - Сортировка по алфавиту
    ///     1 - Сортировка по рейтингу
    ///     (По умолчанию 0)
    func genres(sortingType: Int = 0) async throws -> [String] {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.genres)
        urlComponents?.queryItems = [
            URLQueryItem(name: "sorting_type", value: String(sortingType))
        ]
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode([String].self, from: data)
        return decoded
    }
    
    /// Возвращает список участников команды когда-либо существовавших на проекте.
    func team() async throws -> TeamAPIModel {
        let urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.team)
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(TeamAPIModel.self, from: data)
        return decoded
    }
    
    /// Возвращает список найденных по фильтрам тайтлов
    /// - Parameters:
    ///     - withSearchText: Поиск по именам и описанию
    ///     - year: Список годов выхода (Пример: 2004,2005)
    ///     - season_code: Список сезонов (1 - Зима, 2 - Весна, 3 - Лето, 4 - Осень) (Пример: 1,2)
    ///     - genres: Список жанров (Пример: комедия,музыка)
    ///     - page: Номер страницы для запроса
    ///     - itemsPerPage: Количество запрашиваемых объектов на странице (По умолчанию 10)
    func titleSearch(withSearchText search: String = "",
                     year: String = "",
                     seasonCode: String = "",
                     genres: String = "",
                     page: Int,
                     itemsPerPage: Int = 10) async throws -> ListAPIModel<TitleAPIModel> {
        var urlComponents = URLComponents(string: NetworkConstants.apiAnilibriaURL + NetworkConstants.titleSearch)
        urlComponents?.queryItems = [
            URLQueryItem(name: "search", value: search),
            URLQueryItem(name: "year", value: year),
            URLQueryItem(name: "season_code", value: seasonCode),
            URLQueryItem(name: "genres", value: genres),
            URLQueryItem(name: "playlist_type", value: "array"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage)),
            NetworkConstants.removeTorrents
        ]
        
        let data = try await dataRequest(with: urlComponents, httpMethod: .get)
        let decoded = try jsonDecoder.decode(ListAPIModel<TitleAPIModel>.self, from: data)
        return decoded
    }
}
