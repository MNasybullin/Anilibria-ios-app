//
//  VideoPlayerModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.11.2023.
//

import Foundation

protocol VideoPlayerModelDelegate: AnyObject {
    func configurePlayer(serverUrl: String)
}

final class VideoPlayerModel {
    weak var delegate: VideoPlayerModelDelegate?
    
    func requestCachingNodes() {
        Task(priority: .userInitiated) {
            do {
                let cachingNodes = try await PublicApiService.shared.getCachingNodes()
                guard let cachingNode = cachingNodes.first else {
                    throw MyInternalError.failedToFetchData
                }
                DispatchQueue.main.async {
                    self.delegate?.configurePlayer(serverUrl: "https://" + cachingNode)
                }
            } catch {
                print(error)
            }
        }
    }
}
