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
    private var skips: [(Double, Double)] = []
    
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        self.animeItem = animeItem
        self.currentPlaylist = currentPlaylist
        let hls = animeItem.playlist[currentPlaylist].hls
        setCurrentHLS(hls: hls)
        configureSkips()
    }
}

// MARK: - Private methods

private extension VideoPlayerModel {
    func setCurrentHLS(hls: GTHls) {
        self.currentHLS = hls.fhd ?? hls.hd ?? hls.sd
//        self.currentHLS = hls.sd ?? hls.hd ?? hls.fhd
    }
    
    func pairFromArray(array: [Double]) -> [(Double, Double)] {
        var result: [(Double, Double)] = []
        let stride = stride(from: 0, to: array.count, by: 2)
        for index in stride where index + 1 < array.count {
            let pair = (array[index], array[index + 1])
            result.append(pair)
        }
        return result
    }
    
    func configureSkips() {
        let skips = animeItem.playlist[currentPlaylist].skips
        let opening = pairFromArray(array: skips.opening)
        let ending = pairFromArray(array: skips.ending)
        self.skips = opening + ending
    }
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
    
    func replaceCurrentPlaylist(newPlaylistNumber: Int) {
        currentPlaylist = newPlaylistNumber
        let hls = animeItem.playlist[currentPlaylist].hls
        if [hls.fhd, hls.hd, hls.sd].filter({ $0 == currentHLS }).isEmpty {
            setCurrentHLS(hls: hls)
        }
        requestCachingNodes()
        configureSkips()
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
    
    func getCurrentPlaylistNumber() -> Int {
        return currentPlaylist
    }
    
    func getSkips() -> [(Double, Double)] {
        return skips
    }
}
