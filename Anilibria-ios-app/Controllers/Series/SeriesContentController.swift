//
//  SeriesContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

protocol SeriesContentControllerDelegate: AnyObject {
}

final class SeriesContentController: NSObject {
    weak var delegate: SeriesContentControllerDelegate?
    
    let model: SeriesModel
    var data: [Playlist] = []
    
    init(data: AnimeItem) {
        self.model = SeriesModel(animeItem: data)
        super.init()
        
        self.data = model.getData()
        model.imageModelDelegate = self
    }
}

// MARK: - UITableViewDelegate

extension SeriesContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected ", indexPath)
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
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SeriesTableViewCell.reuseIdentifier, for: indexPath) as? SeriesTableViewCell else {
            fatalError("Can`t create new cell")
        }
        let row = indexPath.row
        let item = data[row]
        if data[row].image == nil {
            model.requestImage(from: item.preview) { [weak self] image in
                self?.data[row].image = image
                cell.setImage(image, urlString: item.preview)
            }
        }
        cell.configureCell(item: item)
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension SeriesContentController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let row = indexPath.row
            guard data[row].image == nil else {
                return
            }
            model.requestImage(from: data[row].preview) { [weak self] image in
                self?.data[row].image = image
            }
        }
    }
}

extension SeriesContentController: ImageModelDelegate {
    func failedRequestImage(error: Error) {
        print(#function, error)
    }
}
