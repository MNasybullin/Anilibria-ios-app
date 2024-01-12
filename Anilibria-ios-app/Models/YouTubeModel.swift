//
//  YouTubeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.12.2023.
//

import Foundation

protocol YouTubeModelDelegate: AnyObject {
    func updateData(_ data: [HomePosterItem])
    func failedRequestData(error: Error)
}

final class YouTubeModel: ImageModel {
    private enum Constants {
        static let limitResults: Int = 10
    }
    weak var delegate: YouTubeModelDelegate?
    
    private let publicApiService = PublicApiService()
    private var rawData: [YouTubeAPIModel]
    private (set) var needLoadMoreData: Bool = true
    
    init(rawData: [YouTubeAPIModel]) {
        self.rawData = rawData
        super.init()
    }
    
    func requestData(after: Int) {
        Task(priority: .userInitiated) {
            do {
                let data = try await publicApiService.getYouTube(withLimit: Constants.limitResults, after: after)
                rawData += data
                let homePosters = data.map { HomePosterItem(fromYouTubeAPIModel: $0) }
                needLoadMoreData = data.count == Constants.limitResults
                delegate?.updateData(homePosters)
            } catch {
                delegate?.failedRequestData(error: error)
            }
        }
    }
    
    func getRawData(row: Int) -> YouTubeAPIModel {
        return rawData[row]
    }
}
