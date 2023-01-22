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
    func requestImageFromData(forIndex index: Int, forViewType viewType: CarouselViewType) async throws -> CarouselViewModel?

}

final class HomeInteractor: HomeInteractorProtocol {
    unowned var presenter: HomePresenterProtocol!
    
    private var todayCarouselViewModel: [CarouselViewModel]?
    private var todayGetTitleModel: [GetTitleModel]?
    
    private var updatesCarouselViewModel: [CarouselViewModel]?
    private var updatesGetTitleModel: [GetTitleModel]?
    
    func requestDataForTodayView(withDayOfTheWeek day: DaysOfTheWeek) async throws -> [CarouselViewModel] {
        do {
            let scheduleModel = try await QueryService.shared.getSchedule(with: [day])
            guard let firstScheduleModel = scheduleModel.first, firstScheduleModel.day == day else {
                throw MyInternalError.failedToFetchData
            }
            var carouselViewModelArray = [CarouselViewModel]()
            firstScheduleModel.list.forEach {
                carouselViewModelArray.append(CarouselViewModel(title: $0.names.ru))
            }
            todayCarouselViewModel = carouselViewModelArray
            todayGetTitleModel = firstScheduleModel.list
            return carouselViewModelArray
        } catch {
            throw error
        }
    }
    
    func requestDataForUpdatesView() async throws -> [CarouselViewModel] {
        do {
            let titleModel = try await QueryService.shared.getUpdates()
            
            var carouselViewModelArray = [CarouselViewModel]()
            titleModel.forEach {
                carouselViewModelArray.append(CarouselViewModel(title: $0.names.ru))
            }
            updatesCarouselViewModel = carouselViewModelArray
            updatesGetTitleModel = titleModel
            return carouselViewModelArray
        } catch {
            throw error
        }
    }
    
    func requestImageFromData(forIndex index: Int, forViewType viewType: CarouselViewType) async throws -> CarouselViewModel? {
        var (carouselViewModel, getTitleModel) = getData(forViewType: viewType)
        guard let imageURL = getTitleModel?[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let image = try await QueryService.shared.getImage(from: imageURL)
            carouselViewModel?[index].image = image
            carouselViewModel?[index].imageIsLoading = false
            return carouselViewModel?[index]
        } catch {
            throw error
        }
    }
    
    private func getData(forViewType viewType: CarouselViewType) -> ([CarouselViewModel]?, [GetTitleModel]?) {
        switch viewType {
            case .todayCarouselView:
                return (todayCarouselViewModel, todayGetTitleModel)
            case .updatesCarouselView:
                return (updatesCarouselViewModel, updatesGetTitleModel)
        }
    }
}
