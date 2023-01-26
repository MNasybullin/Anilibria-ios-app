//
//  ScheduleInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation

protocol ScheduleInteractorProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
    
    func requestScheduleData() async throws -> [PostersListViewModel]
    func requestImageFromData(forSection section: Int, forIndex index: Int) async throws -> PostersListModel?
}

final class ScheduleInteractor: ScheduleInteractorProtocol {
    unowned var presenter: SchedulePresenterProtocol!
    
    private var scheduleModel: [GetScheduleModel]?
    private var postersListViewModel: [PostersListViewModel]?
    
    func requestScheduleData() async throws -> [PostersListViewModel] {
        do {
            let data = try await QueryService.shared.getSchedule(with: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
            scheduleModel = data
            var postersListViewData = [PostersListViewModel]()
            // Converting [GetScheduleModel] -> [PostersListViewModel]
            data.forEach {
                var list = [PostersListModel]()
                $0.list.forEach {
                    list.append(PostersListModel(title: $0.names.ru))
                }
                postersListViewData.append(PostersListViewModel(headerString: $0.day.description, list: list))
            }
            postersListViewModel = postersListViewData
            return postersListViewData
        } catch {
            throw error
        }
    }
    
    func requestImageFromData(forSection section: Int, forIndex index: Int) async throws -> PostersListModel? {
        guard let imageURL = scheduleModel?[section].list[index].posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let image = try await QueryService.shared.getImage(from: imageURL)
            postersListViewModel?[section].list[index].image = image
            postersListViewModel?[section].list[index].imageIsLoading = false
            return postersListViewModel?[section].list[index]
        } catch {
            throw error
        }
    }
}
