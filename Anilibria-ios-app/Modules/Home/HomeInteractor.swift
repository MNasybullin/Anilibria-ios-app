//
//  HomeInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
    
    func requestDataForTodayView() async throws -> [GetScheduleModel]
//    func requestDataForUpdatesView() async throws -> [GetTitleModel]
    func requestImageFromData(withURLString url: String) async throws -> Data

}

final class HomeInteractor: HomeInteractorProtocol {
    unowned var presenter: HomePresenterProtocol!
    
    func requestDataForTodayView() async throws -> [GetScheduleModel] {
        return try await QueryService.shared.getSchedule(with: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
    }
    
//    func requestDataForUpdatesView() async throws -> [GetTitleModel] {
//        let limit = 15
//        do {
//            let data = try await QueryService.shared.getUpdates(with: limit)
//            return data
//        } catch let error as MyNetworkError {
//            throw error
//        } catch {
//            throw MyNetworkError.unknown
//        }
//    }
    
    func requestImageFromData(withURLString url: String) async throws -> Data {
        return try await QueryService.shared.getImage(from: url)
    }
}
