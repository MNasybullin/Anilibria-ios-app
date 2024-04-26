//
//  EpisodesContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

protocol EpisodesContentControllerDelegate: AnyObject {
    var fdInteractivePopDisabled: Bool { get set }
    
    func didSelectItem(animeItem: AnimeItem, currentPlaylist: Int)
}

final class EpisodesContentController: NSObject {
    weak var delegate: EpisodesContentControllerDelegate?
    weak var customView: EpisodesView?
    
    let model: EpisodesModel
    var playlists: [Playlist] = []
    
    init(data: AnimeItem) {
        self.model = EpisodesModel(animeItem: data)
        super.init()
        
        self.playlists = model.getPlaylists()
    }
}

// MARK: - Private methods

private extension EpisodesContentController {
    func cancelRequestImage(indexPath: IndexPath) {
        guard playlists.isEmpty == false else { return }
        let row = indexPath.row
        let item = playlists[row]
        guard item.image == nil else { return }
        model.cancelImageTask(forUrlString: item.previewUrl)
    }
}

// MARK: - Internal methods

extension EpisodesContentController {
    func viewIsAppearing() {
        if model.hasWatchingEntity == false {
            model.requestWatchingEntity()
        }
        customView?.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension EpisodesContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let animeItem = model.getAnimeItem()
        delegate?.didSelectItem(animeItem: animeItem, currentPlaylist: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelRequestImage(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minScreenSize = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let imageRatio: CGFloat = 1920/1080
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let fraction = isPhone ? 0.5 : 0.3
        return (minScreenSize * fraction) / imageRatio
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !model.isUserAuthorized() {
            return nil
        }
        let episode = playlists[indexPath.row].episode
        
        var title: String
        var info: EpisodesModel.WatchingInfo
        var image: UIImage?
        
        if model.getWatchingInfo(forEpisode: episode) != nil {
            title = Strings.EpisodesModule.SwipeActions.removeFromWatching
            info = .notWatched
            image = UIImage(systemName: "rectangle.badge.xmark")
        } else {
            title = Strings.EpisodesModule.SwipeActions.markAsWatched
            info = .fullWatched
            image = UIImage(systemName: "rectangle.badge.checkmark")
        }
        
        let action = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completion in
            self?.model.setWatchingInfo(forEpisode: self?.playlists[indexPath.row].episode, info: info)
            tableView.reconfigureRows(at: [indexPath])
            completion(true)
        }
        action.backgroundColor = .darkClouds
        action.image = image
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        delegate?.fdInteractivePopDisabled = true
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        delegate?.fdInteractivePopDisabled = false
    }
}

// MARK: - UITableViewDataSource

extension EpisodesContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EpisodesHeaderSupplementaryView.reuseIdentifier) as? EpisodesHeaderSupplementaryView else {
            fatalError("Can`t create new header")
        }
        let episodesDescription = model.getEpisodesDescription()
        header.configureTitleLabel(text: episodesDescription)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesTableViewCell.reuseIdentifier, for: indexPath) as? EpisodesTableViewCell else {
            fatalError("Can`t create new cell")
        }
        let row = indexPath.row
        let item = playlists[row]
        if item.image == nil {
            Task { [weak self] in
                guard let self else { return }
                let image = try await self.model.requestImage(fromUrlString: item.previewUrl)
                self.playlists[row].image = image
                cell.setImage(image, urlString: item.previewUrl)
            }
        }
        let watchingInfo = model.getWatchingInfo(forEpisode: item.episode)
        cell.configureCell(
            item: playlists[row],
            duration: watchingInfo?.duration,
            playbackTime: watchingInfo?.playbackTime)
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension EpisodesContentController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let row = indexPath.row
            guard playlists[row].image == nil else {
                return
            }
            Task { [weak self] in
                guard let self else { return }
                let image = try? await self.model.requestImage(fromUrlString: playlists[row].previewUrl)
                self.playlists[row].image = image
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cancelRequestImage(indexPath: indexPath)
        }
    }
}
