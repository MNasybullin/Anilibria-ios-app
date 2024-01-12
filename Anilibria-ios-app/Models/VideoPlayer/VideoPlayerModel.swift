//
//  VideoPlayerModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.11.2023.
//

import UIKit

protocol VideoPlayerModelDelegate: AnyObject {
    func configurePlayerItem(url: URL)
    func configurePlayerItem(url: URL, playbackPostition: Double)
    func configurePlayerItemWithCurrentPlaybackTime(url: URL)
}

final class VideoPlayerModel {
    weak var delegate: VideoPlayerModelDelegate?
    
    private let publicApiService = PublicApiService()
    
    private var animeItem: AnimeItem
    private (set) var currentPlaylistNumber: Int
    private (set) var currentHLS: HLS?
    private (set) var skips: [(Double, Double)] = []
    private (set) var currentRate: Float = 1.0
    private var cachingNodes: [String] = []
    
    // CoreData Properties
    private let coreDataService = CoreDataService.shared
    private var userEntity: UserEntity?
    private var watchingEntity: WatchingEntity?
    private var currentSerieEntity: SeriesEntity?
    
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        self.animeItem = animeItem
        self.currentPlaylistNumber = currentPlaylist
        let hls = animeItem.playlist[currentPlaylist].hls
        setCurrentHLS(hls: hls)
        configureSkips()
        setupCurrentSerieEntity()
    }
    
    deinit {
        coreDataService.saveContext()
    }
}

// MARK: - Private methods

private extension VideoPlayerModel {
    func setCurrentHLS(hls: [HLS]) {
        currentHLS = hls.first
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

// MARK: - CoreData methods
extension VideoPlayerModel {
    private func setupCurrentSerieEntity() {
        guard let userId = UserDefaults.standard.userId else { return }
        do {
            if userEntity == nil {
                userEntity = try UserEntity.find(userId: userId, context: coreDataService.viewContext)
            }
            if watchingEntity == nil {
                watchingEntity = try WatchingEntity.find(forUser: userEntity!, animeId: animeItem.id, context: coreDataService.viewContext)
            }
            let series = watchingEntity?.series as? Set<SeriesEntity>
            currentSerieEntity = series?.filter({ $0.numberOfSerie == animeItem.playlist[currentPlaylistNumber].serie }).first
        } catch {
            print(error)
        }
    }
    
    private func createWatchingEntity(animeId: Int) {
        watchingEntity = WatchingEntity(context: coreDataService.viewContext)
        watchingEntity?.animeId = Int64(animeItem.id)
        watchingEntity?.user = userEntity
    }
    
    private func createCurrentSerieEntity(duration: Double, playbackPosition: Double) {
        currentSerieEntity = SeriesEntity(context: coreDataService.viewContext)
        currentSerieEntity?.duration = duration
        currentSerieEntity?.numberOfSerie = animeItem.playlist[currentPlaylistNumber].serie ?? 0
        currentSerieEntity?.playbackPosition = playbackPosition
        currentSerieEntity?.watchingDate = Date()
        currentSerieEntity?.watching = watchingEntity
    }
    
    func configureWatchingInfo(duration: Double, playbackPosition: Double) {
        if let currentSerieEntity {
            currentSerieEntity.duration = duration
            currentSerieEntity.playbackPosition = playbackPosition
            currentSerieEntity.watchingDate = Date()
        } else if userEntity != nil {
            if watchingEntity == nil {
                createWatchingEntity(animeId: animeItem.id)
            }
            createCurrentSerieEntity(duration: duration, playbackPosition: playbackPosition)
        }
    }
}

// MARK: - Internal methods

extension VideoPlayerModel {
    func requestCachingNodes() {
        Task(priority: .userInitiated) {
            do {
                cachingNodes = try await publicApiService.getCachingNodes()
                guard let cachingNode = cachingNodes.first, let currentHLS else {
                    throw MyInternalError.failedToFetchData
                }
                guard let url = URL(string: "https://" + cachingNode + currentHLS.url) else {
                    throw MyInternalError.failedToFetchURLFromData
                }
                DispatchQueue.main.async {
                    if let currentSerie = self.currentSerieEntity {
                        self.delegate?.configurePlayerItem(url: url, playbackPostition: currentSerie.playbackPosition)
                    } else {
                        self.delegate?.configurePlayerItem(url: url)
                    }
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
            currentHLS = hlsFiltered.first
        }
        setupCurrentSerieEntity()
        requestCachingNodes()
        configureSkips()
    }
    
    func changeCurrentHLS(_ hls: HLS) {
        currentHLS = hls
        guard let cachingNode = cachingNodes.first else {
            print(MyInternalError.failedToFetchData)
            return
        }
        guard let url = URL(string: "https://" + cachingNode + hls.url) else {
            print(MyInternalError.failedToFetchURLFromData)
            return
        }
        delegate?.configurePlayerItemWithCurrentPlaybackTime(url: url)
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
