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
    private (set) var currentPlaylistNumber: Int
    private (set) var currentHLS: HLS?
    private (set) var skips: [(Double, Double)] = []
    private (set) var currentRate: Float = 1.0
    
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        self.animeItem = animeItem
        self.currentPlaylistNumber = currentPlaylist
        let hls = animeItem.playlist[currentPlaylist].hls
        setCurrentHLS(hls: hls)
        configureSkips()
    }
}

// MARK: - Private methods

private extension VideoPlayerModel {
    func setCurrentHLS(hls: [HLS]) {
        currentHLS = hls.first
//        return hls.sd ?? hls.hd ?? hls.fhd!
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
        let skips = animeItem.playlist[currentPlaylistNumber].skips
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
                guard let url = URL(string: "https://" + cachingNode + currentHLS.url) else {
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
        currentPlaylistNumber = newPlaylistNumber
        let hls = animeItem.playlist[currentPlaylistNumber].hls
        let hlsFiltered = hls.filter { $0.description == currentHLS?.description }
        if hlsFiltered.isEmpty {
            setCurrentHLS(hls: hls)
        } else {
            currentHLS = hls.first
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
        return animeItem.playlist[currentPlaylistNumber].serieString
    }
    
    func getAnimeImage() -> UIImage? {
        return animeItem.image
    }
    
    func setCurrentRate(_ rate: Float) {
        self.currentRate = rate
    }
    
    func getHLS() -> [HLS] {
        return animeItem.playlist[currentPlaylistNumber].hls
    }
}
