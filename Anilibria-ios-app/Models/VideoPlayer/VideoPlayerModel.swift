//
//  VideoPlayerModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.11.2023.
//

import UIKit
import OSLog

protocol VideoPlayerModelDelegate: AnyObject {
    func configurePlayerItem(url: URL)
    func configurePlayerItem(url: URL, playbackPostition: Double)
    func configurePlayerItemWithCurrentPlaybackTime(url: URL)
    func closePlayerWithAlert(title: String, message: String)
}

final class VideoPlayerModel {
    weak var delegate: VideoPlayerModelDelegate?
    
    private let publicApiService = PublicApiService()
    private let logger = Logger(subsystem: .videoPlayer, category: .empty)
    
    private var animeItem: AnimeItem
    private(set) var currentPlaylistNumber: Int
    private(set) var currentHLS: HLS?
    private(set) var skips: [(Double, Double)] = []
    private(set) var currentRate: Float = 1.0
    
    private let userDefaults = UserDefaults.standard
    
    // CoreData Properties
    private let coreDataService = CoreDataService.shared
    private var userEntity: UserEntity?
    private var watchingEntity: WatchingEntity?
    private var currentEpisodeEntity: EpisodesEntity?
    
    init(animeItem: AnimeItem, currentPlaylist: Int) {
        self.animeItem = animeItem
        self.currentPlaylistNumber = currentPlaylist
        let hls = animeItem.playlist[currentPlaylist].hls
        setCurrentHLS(hls: hls)
        configureSkips()
        setupCurrentEpisodeEntity()
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
    private func setupCurrentEpisodeEntity() {
        guard let userLogin = userDefaults.userLogin else { return }
        do {
            if userEntity == nil {
                userEntity = try UserEntity.find(userLogin: userLogin, context: coreDataService.viewContext)
            }
            if watchingEntity == nil {
                watchingEntity = try WatchingEntity.find(forUser: userEntity!, animeId: animeItem.id, context: coreDataService.viewContext)
            }
            let episodes = watchingEntity?.episodes as? Set<EpisodesEntity>
            currentEpisodeEntity = episodes?.filter({ $0.numberOfEpisode == animeItem.playlist[currentPlaylistNumber].episode }).first
        } catch {
            let coreDataLogger = Logger(subsystem: .videoPlayer, category: .coreData)
            coreDataLogger.error("\(Logger.logInfo(error: error))")
        }
    }
    
    func configureWatchingInfo(duration: Double, playbackPosition: Double, image: UIImage?) {
        if let currentEpisodeEntity {
            currentEpisodeEntity.duration = duration
            currentEpisodeEntity.playbackPosition = playbackPosition
            currentEpisodeEntity.watchingDate = Date()
            currentEpisodeEntity.watching?.animeImage = image
            currentEpisodeEntity.watching?.isHidden = false
        } else if userEntity != nil {
            if watchingEntity == nil {
                watchingEntity = WatchingEntity.create(forUser: userEntity!,
                                                       animeItem: animeItem,
                                                       context: coreDataService.viewContext)
            }
            currentEpisodeEntity = EpisodesEntity.create(forWatching: watchingEntity!,
                                                         context: coreDataService.viewContext,
                                                         duration: duration,
                                                         playbackPosition: playbackPosition,
                                                         numberOfEpisode: animeItem.playlist[currentPlaylistNumber].episode,
                                                         image: image)
        }
    }
}

// MARK: - Internal methods

extension VideoPlayerModel {
    func start() {
        do {
            guard let host = animeItem.host, let currentHLS = currentHLS?.url else {
                throw MyInternalError.failedToFetchData
            }
            guard let url = URL(string: "https://" + host + currentHLS) else {
                throw MyInternalError.failedToFetchURLFromData
            }
            if let currentEpisode = self.currentEpisodeEntity {
                self.delegate?.configurePlayerItem(url: url, playbackPostition: currentEpisode.playbackPosition)
            } else {
                self.delegate?.configurePlayerItem(url: url)
            }
        } catch {
            logger.error("\(Logger.logInfo(error: error))")
            delegate?.closePlayerWithAlert(title: Strings.VideoPlayer.error, message: error.localizedDescription)
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
        setupCurrentEpisodeEntity()
        configureSkips()
        start()
    }
    
    func changeCurrentHLS(_ hls: HLS) {
        currentHLS = hls
        guard let host = animeItem.host else {
            logger.error("\(Logger.logInfo(error: MyInternalError.failedToFetchData))")
            return
        }
        guard let url = URL(string: "https://" + host + hls.url) else {
            logger.error("\(Logger.logInfo(error: MyInternalError.failedToFetchURLFromData))")
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
        return animeItem.playlist[currentPlaylistNumber].episodeString
    }
    
    func getAnimeImage() -> UIImage? {
        return animeItem.image ?? watchingEntity?.animeImage
    }
    
    func setCurrentRate(_ rate: Float) {
        self.currentRate = rate
    }
    
    func getHLS() -> [HLS] {
        return animeItem.playlist[currentPlaylistNumber].hls
    }
}

// MARK: - Static func

extension VideoPlayerModel {
    static func requestAnimeData(id: Int) async throws -> AnimeItem {
        let titleApiModel = try await PublicApiService().title(id: String(id))
        return AnimeItem(fromTitleApiModel: titleApiModel, image: nil)
    }
}
