//
//  HomeUpdatesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

final class HomeUpdatesModel: AnimePosterModel, HomeModelInput {
    typealias DataBlock = ([AnimePosterItem], HomeView.Section)
    typealias ResultDataBlock = (Result<DataBlock, Error>) -> Void
    
    private var rawData: [TitleAPIModel] = []
    
    weak var homeModelOutput: HomeModelOutput?
    
    private func requestData(completionHanlder: @escaping ResultDataBlock) {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task {
            defer { isDataTaskLoading = false }
            do {
                let data = try await PublicApiService.shared.getUpdates()
                rawData = data
                let animeTitleModels = data.map { AnimePosterItem(titleAPIModel: $0) }
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
                    self?.homeModelOutput?.updateData(items: items, section: section)
                case .failure(let error):
                    print(#function, error)
            }
        }
    }
    
    func refreshData() {
        requestData { [weak self] result in
            switch result {
                case .success((let items, let section)):
                    self?.homeModelOutput?.refreshData(items: items, section: section)
                case .failure(let error):
                    self?.homeModelOutput?.failedRefreshData(error: error)
            }
        }
    }
    
    func getRawData(row: Int) -> TitleAPIModel? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[row]
    }
}
