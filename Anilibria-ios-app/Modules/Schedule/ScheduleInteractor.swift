//
//  ScheduleInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation

protocol ScheduleInteractorProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
    
    func requestScheduleData() async throws -> [GetScheduleModel]
    func requestImageData(forSection section: Int, forIndex index: Int) async throws -> GTImageData?
}

final class ScheduleInteractor: ScheduleInteractorProtocol {
    unowned var presenter: SchedulePresenterProtocol!
    
    private var scheduleModel: [GetScheduleModel]?
    
    func requestScheduleData() async throws -> [GetScheduleModel] {
        do {
            let data = try await QueryService.shared.getSchedule(with: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
            scheduleModel = data
            return data
        } catch {
            throw error
        }
    }
    
    func requestImageData(forSection section: Int, forIndex index: Int) async throws -> GTImageData? {
        guard let imageURL = scheduleModel?[section].list[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await QueryService.shared.getImageData(from: imageURL)
            let gtImageData = GTImageData(data: imageData, imageIsLoading: false)
            scheduleModel?[section].list[index].imageData = gtImageData
            return gtImageData
        } catch {
            throw error
        }
    }
}
