//
//  EpisodesContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

protocol EpisodesContentControllerDelegate: AnyObject {
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
        let watchingInfo = model.getWatchingInfo(forEpisode: item.episode ?? -1)
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
