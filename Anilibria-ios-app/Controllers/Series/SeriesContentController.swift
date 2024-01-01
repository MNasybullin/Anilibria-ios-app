//
//  SeriesContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

protocol SeriesContentControllerDelegate: AnyObject {
    func didSelectItem(animeItem: AnimeItem, currentPlaylist: Int)
}

final class SeriesContentController: NSObject {
    weak var delegate: SeriesContentControllerDelegate?
    
    let model: SeriesModel
    var playlists: [Playlist] = []
    
    init(data: AnimeItem) {
        self.model = SeriesModel(animeItem: data)
        super.init()
        
        model.imageModelDelegate = self
        self.playlists = model.getPlaylists()
    }
}

// MARK: - UITableViewDelegate

extension SeriesContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let animeItem = model.getAnimeItem()
        delegate?.didSelectItem(animeItem: animeItem, currentPlaylist: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension SeriesContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SeriesHeaderSupplementaryView.reuseIdentifier) as? SeriesHeaderSupplementaryView else {
            fatalError("Can`t create new header")
        }
        let seriesDescription = model.getSeriesDescription()
        header.configureTitleLabel(text: seriesDescription)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.reuseIdentifier, for: indexPath) as? SeriesTableViewCell else {
            fatalError("Can`t create new cell")
        }
        let row = indexPath.row
        let item = playlists[row]
        if item.image == nil {
            model.requestImage(from: item.previewUrl) { [weak self] image in
                self?.playlists[row].image = image
                cell.setImage(image, urlString: item.previewUrl)
            }
        }
        let watchingInfo = model.getWatchingInfo(forSerie: item.serie ?? -1)
        cell.configureCell(
            item: playlists[row],
            duration: watchingInfo?.duration,
            playbackTime: watchingInfo?.playbackTime)
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension SeriesContentController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let row = indexPath.row
            guard playlists[row].image == nil else {
                return
            }
            model.requestImage(from: playlists[row].previewUrl) { [weak self] image in
                self?.playlists[row].image = image
            }
        }
    }
}

extension SeriesContentController: ImageModelDelegate {
    func failedRequestImage(error: Error) {
        print(#function, error)
    }
}
