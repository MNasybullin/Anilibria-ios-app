//
//  VideoPlayerModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.11.2023.
//

import UIKit

protocol VideoPlayerModelDelegate: AnyObject {
    func configurePlayerItem(url: URL)
}

final class VideoPlayerModel {
    weak var delegate: VideoPlayerModelDelegate?
    
    private let publicApiService = PublicApiService()
    
    private var animeItem: AnimeItem
    private var currentPlaylist: Int
    private var currentHLS: String?
    
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        self.animeItem = animeItem
        self.currentPlaylist = currentPlaylist
        let hls = animeItem.playlist[currentPlaylist].hls
        self.currentHLS = hls.fhd ?? hls.hd ?? hls.sd
    }
}

// MARK: - Private methods

private extension VideoPlayerModel {
}

// MARK: - Internal methods

extension VideoPlayerModel {
    func requestCachingNodes() {
        Task(priority: .userInitiated) {
            do {
                let cachingNodes = try await publicApiService.getCachingNodes()
                guard let cachingNode = cachingNodes.first, let currentHLS else {
                    throw MyInternalError.failedToFetchData
                }
                guard let url = URL(string: "https://" + cachingNode + currentHLS) else {
                    throw MyInternalError.failedToFetchURLFromData
                }
                DispatchQueue.main.async {
                    self.delegate?.configurePlayerItem(url: url)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getData() -> AnimeItem {
        return animeItem
    }
    
    func getTitle() -> String {
        return animeItem.ruName
    }
    
    func getSubtitle() -> String {
        return animeItem.playlist[currentPlaylist].serieString
    }
    
    func getAnimeImage() -> UIImage? {
        return animeItem.image
    }
}
