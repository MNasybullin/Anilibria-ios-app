//
//  HomeUpdatesModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import Foundation

final class HomeUpdatesModel: ImageModel, HomeModelInput {
    weak var homeModelOutput: HomeModelOutput?
    
    private let publicApiService = PublicApiService()
    
    private var rawData: [TitleAPIModel] = []
    var isDataTaskLoading = false
    
    func requestData() {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task(priority: .userInitiated) {
            defer { isDataTaskLoading = false }
            do {
                let data = try await publicApiService.getUpdates()
                rawData = data
                let animeTitleModels = data.map { AnimePosterItem(titleAPIModel: $0) }
                homeModelOutput?.updateData(items: animeTitleModels, section: .updates)
            } catch {
                homeModelOutput?.failedRequestData(error: error)
            }
        }
    }
        
    func getRawData(row: Int) -> TitleAPIModel? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[row]
    }
}
