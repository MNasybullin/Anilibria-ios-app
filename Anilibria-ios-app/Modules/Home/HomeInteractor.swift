//
//  HomeInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation
import UIKit

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
    
    func requestDataForTodayView(withDayOfTheWeek day: DaysOfTheWeek) async throws -> [GetTitleModel]
    func requestDataForUpdatesView() async throws -> [GetTitleModel]
    func requestImageData(forIndex index: Int, forViewType viewType: CarouselViewType) async throws -> GTImageData?
    func getData(forViewType viewType: CarouselViewType) -> [GetTitleModel]?
}

final class HomeInteractor: HomeInteractorProtocol {
    unowned var presenter: HomePresenterProtocol!
    
    private var todayGetTitleModel: [GetTitleModel]?
    
    private var updatesGetTitleModel: [GetTitleModel]?
    
    func requestDataForTodayView(withDayOfTheWeek day: DaysOfTheWeek) async throws -> [GetTitleModel] {
        do {
            let scheduleModel = try await QueryService.shared.getSchedule(with: [day])
            guard let firstScheduleModel = scheduleModel.first, firstScheduleModel.day == day else {
                throw MyInternalError.failedToFetchData
            }
            todayGetTitleModel = firstScheduleModel.list
            return firstScheduleModel.list
        } catch {
            throw error
        }
    }
    
    func requestDataForUpdatesView() async throws -> [GetTitleModel] {
        do {
            let titleModel = try await QueryService.shared.getUpdates()
            updatesGetTitleModel = titleModel
            return titleModel
        } catch {
            throw error
        }
    }
    
    func requestImageData(forIndex index: Int, forViewType viewType: CarouselViewType) async throws -> GTImageData? {
        var getTitleModel = getData(forViewType: viewType)
        guard let imageURL = getTitleModel?[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await QueryService.shared.getImageData(from: imageURL)
            let gtImageData = GTImageData(data: imageData, imageIsLoading: false)
            getTitleModel?[index].imageData = gtImageData
            return gtImageData
        } catch {
            throw error
        }
    }
    
    func getData(forViewType viewType: CarouselViewType) -> [GetTitleModel]? {
        switch viewType {
            case .todayCarouselView:
                return todayGetTitleModel
            case .updatesCarouselView:
                return updatesGetTitleModel
        }
    }
}
