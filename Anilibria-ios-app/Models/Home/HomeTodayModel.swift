//
//  HomeTodayModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

final class HomeTodayModel: HomeBaseModel, HomeModelInput {
    private func requestData(completionHanlder: @escaping ResultDataBlock) {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task {
            defer { isDataTaskLoading = false }
            do {
                let data = try await PublicApiService.shared.getSchedule(with: [.currentDayOfTheWeek()])
                guard let todayTitleModels = data.first?.list else {
                    throw MyInternalError.failedToFetchData
                }
                rawData = todayTitleModels
                let animeTitleModels = todayTitleModels.map { AnimePosterItem(from: $0) }
                completionHanlder(.success((animeTitleModels, .today)))
            } catch {
                completionHanlder(.failure(error))
            }
        }
    }
    
    func requestData() {
        requestData { [weak self] result in
            switch result {
                case .success((let items, let section)):
                    self?.output?.updateData(items: items, section: section)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func refreshData() {
        requestData { [weak self] result in
            switch result {
                case .success((let items, let section)):
                    self?.output?.refreshData(items: items, section: section)
                case .failure(let error):
                    self?.output?.failedRefreshData(error: error)
            }
        }
    }
}
