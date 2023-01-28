//
//  UpdatesInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation

protocol UpdatesInteractorProtocol: AnyObject {
    var presenter: UpdatesPresenterProtocol! { get set }
    
    func getData() -> [GetScheduleModel]?
    func requestUpdatesData() async throws -> [GetScheduleModel]
    func requestImageData(forSection section: Int, forIndex index: Int) async throws -> GTImageData?
}

final class UpdatesInteractor: UpdatesInteractorProtocol {
    unowned var presenter: UpdatesPresenterProtocol!
    
    var titleModel: [GetTitleModel]?
    
    func getData() -> [GetScheduleModel]? {
        guard let data = titleModel else { return nil }
        var scheduleModel = [GetScheduleModel]()
        scheduleModel.append(GetScheduleModel(day: nil, list: data))
        return scheduleModel
    }
    
    func requestUpdatesData() async throws -> [GetScheduleModel] {
        do {
            let data = try await QueryService.shared.getUpdates()
            titleModel = data
            var scheduleModel = [GetScheduleModel]()
            scheduleModel.append(GetScheduleModel(day: nil, list: data))
            return scheduleModel
        } catch {
            throw error
        }
    }
    
    func requestImageData(forSection section: Int, forIndex index: Int) async throws -> GTImageData? {
        guard let imageURL = titleModel?[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await QueryService.shared.getImageData(from: imageURL)
            let gtImageData = GTImageData(data: imageData, imageIsLoading: false)
            titleModel?[index].imageData = gtImageData
            return gtImageData
        } catch {
            throw error
        }
    }
}
