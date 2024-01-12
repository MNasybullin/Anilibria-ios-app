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
                let homePosters = data.map { HomePosterItem(fromTitleAPIModel: $0) }
                homeModelOutput?.updateData(items: homePosters, section: .updates)
            } catch {
                homeModelOutput?.failedRequestData(error: error)
            }
        }
    }
        
    func getRawData(row: Int) -> Any? {
        guard rawData.isEmpty == false else { return nil }
        return rawData[row]
    }
    
    func getRawData() -> [Any] {
        return rawData
    }
}
