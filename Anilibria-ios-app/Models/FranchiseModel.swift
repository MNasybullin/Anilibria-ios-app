//
//  FranchiseModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import Foundation

final class FranchiseModel: ImageModel {
    private let publicAPIService = PublicApiService()
    
    private let franchisesData: [FranchisesAPIModel]
    private var titlesData: [TitleAPIModel]?
    
    init(franchisesData: [FranchisesAPIModel]) {
        self.franchisesData = franchisesData
    }
}

// MARK: - Private methods

private extension FranchiseModel {
    func getTitleIds() -> String {
        var titleIds = ""
        franchisesData.forEach { franchise in
            franchise.releases.forEach { release in
                titleIds += "\(release.id),"
            }
        }
        return titleIds
    }
    
    func getPosterItems(from titles: [TitleAPIModel]) -> [[HomePosterItem]] {
        var posterItems = [[HomePosterItem]]()
        
        franchisesData.forEach { franchise in
            var indexPosterItem = [HomePosterItem]()
            franchise.releases.forEach { release in
                let title = titles.first(where: { $0.id == release.id })!
                indexPosterItem.append(HomePosterItem(fromTitleAPIModel: title))
            }
            posterItems.append(indexPosterItem)
        }
        
        return posterItems
    }
}

// MARK: - Internal Methods

extension FranchiseModel {
    func getFranchisesTitles() async throws -> [[HomePosterItem]] {
        let titleIds = getTitleIds()
        let titles = try await publicAPIService.titleList(ids: titleIds)
        titlesData = titles
        var posterItems = getPosterItems(from: titles)
        return posterItems
    }
}
