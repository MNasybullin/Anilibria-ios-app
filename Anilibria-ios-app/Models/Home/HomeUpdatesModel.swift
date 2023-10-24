//
//  HomeUpdatesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

final class HomeUpdatesModel: HomeBaseModel, HomeModelInput {
    private func requestData(completionHanlder: @escaping ResultDataBlock) {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task {
            defer { isDataTaskLoading = false }
            do {
                let data = try await PublicApiService.shared.getUpdates()
                rawData = data
                let animeTitleModels = data.map { AnimePosterItem(from: $0) }
                completionHanlder(.success((animeTitleModels, .updates)))
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
