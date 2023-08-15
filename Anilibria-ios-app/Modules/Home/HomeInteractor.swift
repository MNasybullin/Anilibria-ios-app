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
    
    func requestDataForTodayView(withDayOfTheWeek day: DaysOfTheWeek) async throws -> [CarouselViewModel]
    func requestDataForUpdatesView() async throws -> [CarouselViewModel]
    func requestImage(forIndex index: Int, forViewType viewType: CarouselViewType) async throws -> UIImage
    func getData(forViewType viewType: CarouselViewType) -> [GetTitleModel]?
}

final class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomePresenterProtocol!
    private var todayGetTitleModel: [GetTitleModel]?
    private var updatesGetTitleModel: [GetTitleModel]?
    
    func requestDataForTodayView(withDayOfTheWeek day: DaysOfTheWeek) async throws -> [CarouselViewModel] {
        do {
            let scheduleModel = try await PublicApiService.shared.getSchedule(with: [day])
            guard let firstScheduleModel = scheduleModel.first, firstScheduleModel.day == day else {
                throw MyInternalError.failedToFetchData
            }
            todayGetTitleModel = firstScheduleModel.list
            return convertGetTitleModelToCarouselViewModel(firstScheduleModel.list)
        } catch {
            throw error
        }
    }
    
    func requestDataForUpdatesView() async throws -> [CarouselViewModel] {
        do {
            let titleModel = try await PublicApiService.shared.getUpdates()
            updatesGetTitleModel = titleModel
            return convertGetTitleModelToCarouselViewModel(titleModel)
        } catch {
            throw error
        }
    }
    
    func requestImage(forIndex index: Int, forViewType viewType: CarouselViewType) async throws -> UIImage {
        let getTitleModel = getData(forViewType: viewType)
        guard let imageURL = getTitleModel?[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchURLFromData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            guard let image = UIImage(data: imageData) else {
                throw MyImageError.failedToInitialize
            }
            return image
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
    
    // MARK: - Private Functions
    private func convertGetTitleModelToCarouselViewModel(_ titleModel: [GetTitleModel]) -> [CarouselViewModel] {
        var carouselViewModel = [CarouselViewModel]()
        titleModel.forEach {
            carouselViewModel.append(CarouselViewModel(name: $0.names.ru))
        }
        return carouselViewModel
    }
}
