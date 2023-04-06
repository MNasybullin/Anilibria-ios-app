//
//  ScheduleInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation
import UIKit

protocol ScheduleInteractorProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
    
    func getData() -> [GetScheduleModel]? 
    func requestScheduleData() async throws -> [PostersListViewModel]
    func requestImage(forSection section: Int, forIndex index: Int) async throws -> UIImage?
}

final class ScheduleInteractor: ScheduleInteractorProtocol {
    unowned var presenter: SchedulePresenterProtocol!
    private var scheduleModel: [GetScheduleModel]?
    
    func getData() -> [GetScheduleModel]? {
        return scheduleModel
    }
    
    func requestScheduleData() async throws -> [PostersListViewModel] {
        do {
            let data = try await PublicApiService.shared.getSchedule(with: DaysOfTheWeek.allCases)
            scheduleModel = data
            return convertScheduleModelToPostersListViewModel(data)
        } catch {
            throw error
        }
    }
    
    func requestImage(forSection section: Int, forIndex index: Int) async throws -> UIImage? {
        guard let imageURL = scheduleModel?[section].list[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            return UIImage(data: imageData)
        } catch {
            throw error
        }
    }
    
    // MARK: - Private Functions
    
    private func convertScheduleModelToPostersListViewModel(_ scheduleModel: [GetScheduleModel]) -> [PostersListViewModel] {
        var postersListViewModel = [PostersListViewModel]()
        scheduleModel.forEach {
            var postersListModel = [PostersListModel]()
            $0.list.forEach {
                postersListModel.append(PostersListModel(name: $0.names.ru))
            }
            postersListViewModel.append(PostersListViewModel(headerName: $0.day?.description, postersList: postersListModel))
        }
        return postersListViewModel
    }
}
