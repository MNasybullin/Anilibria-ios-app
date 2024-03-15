//
//  SearchResultsController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.11.2023.
//

import UIKit
import SkeletonView
import OSLog

protocol SearchResultsControllerDelegate: AnyObject {
    func didSelectedItem(item: TitleAPIModel, image: UIImage?)
}

final class SearchResultsController: UIViewController, HasCustomView {
    typealias CustomView = SearchResultsView
    
    enum Status {
        case skeleton
        case normal
        case notFound
        case loadingMore
        case loadingMoreFail
    }
    
    private var status: Status = .skeleton {
        didSet {
            updateHeaderFooterView()
        }
    }
    
    private var data: [SearchResultsItem] = []
    private let model = SearchResultsModel()
    
    private var searchText: String?
    
    weak var delegate: SearchResultsControllerDelegate?
    
    // MARK: LifeCycle
    override func loadView() {
        view = SearchResultsView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
    }
}

// MARK: - Private methods

private extension SearchResultsController {
    func updateHeaderFooterView() {
        DispatchQueue.main.async {
            self.customView.updateHeaderFooterView(status: self.status)
        }
    }
    
    func loadMoreData() {
        guard model.needLoadMoreData == true,
                status != .loadingMore,
                let searchText = searchText  else { return }
        status = .loadingMore
        model.searchTitles(searchText: searchText, after: data.count)
    }
    
    func cancelRequestImage(indexPath: IndexPath) {
        let row = indexPath.row
        guard status != .skeleton, row < data.count else {
            return
        }
        
        let item = data[row]
        guard item.image == nil else {
            return
        }
        model.cancelImageTask(forUrlString: item.imageUrlString)
    }
}

// MARK: - Internal methods

extension SearchResultsController {
    func searchTitle(searchText: String) {
        self.searchText = searchText
        status = .skeleton
        model.searchTitles(searchText: searchText, after: 0)
    }
    
    func cancelTasks() {
        searchText = nil
        data.removeAll()
        status = .normal
        customView.hideTableViewSkeleton()
        customView.reloadData()
        model.cancelTasks()
        model.deleteData()
    }
}

// MARK: - UITableViewDelegate

extension SearchResultsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = model.getRawData(row: indexPath.row) else {
            return
        }
        model.cancelTasks()
        let image = data[indexPath.row].image
        delegate?.didSelectedItem(item: item, image: image)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.2
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelRequestImage(indexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension SearchResultsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultsTableViewCell else {
            fatalError("Can`t create new cell")
        }
        let item = data[indexPath.row]
        if indexPath.row == data.count - 4 {
            loadMoreData()
        }
        if item.image == nil {
            Task { [weak self] in
                guard let self else { return }
                do {
                    let image = try await self.model.requestImage(fromUrlString: item.imageUrlString)
                    self.data[indexPath.row].image = image
                    cell.setImage(image, urlString: item.imageUrlString)
                } catch {
                    cell.imageViewStopSkeletonAnimation()
                }
            }
        }
        cell.configureCell(item: item)
        return cell
    }
}

// MARK: - SkeletonTableViewDataSource

extension SearchResultsController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SearchResultsTableViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension SearchResultsController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard status != .skeleton else {
            return
        }
        indexPaths.forEach { indexPath in
            let item = data[indexPath.row]
            guard item.image == nil else {
                return
            }
            Task { [weak self] in
                guard let self else { return }
                let image = try? await self.model.requestImage(fromUrlString: item.imageUrlString)
                if data.indices.contains(indexPath.row) {
                    self.data[indexPath.row].image = image
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cancelRequestImage(indexPath: indexPath)
        }
    }
}

// MARK: - SearchResultsModelDelegate

extension SearchResultsController: SearchResultsModelDelegate {
    func update(newData: [SearchResultsItem], afterValue: Int) {
        DispatchQueue.main.async {
            if afterValue == 0 {
                self.customView.hideTableViewSkeleton()
                if newData.isEmpty {
                    self.status = .notFound
                } else {
                    self.data = newData
                    self.status = .normal
                    self.customView.reloadData()
                    self.customView.scrollToTop()
                }
            } else {
                let count = self.data.count
                let indexPaths = (0..<newData.count).map {
                    IndexPath(row: $0 + count, section: 0)
                }
                self.data.append(contentsOf: newData)
                self.status = .normal
                self.customView.insertRows(indexPaths: indexPaths)
            }
        }
    }
    
    func failedRequestData(error: Error, afterValue: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if afterValue != 0 {
                self.status = .loadingMoreFail
            }
            let logger = Logger(subsystem: .search, category: .data)
            logger.error("\(Logger.logInfo(error: error))")
            
            let data = NotificationBannerView.BannerData(title: Strings.SearchModule.Error.searchError,
                                                         detail: error.localizedDescription,
                                                         type: .error)
            NotificationBannerView(data: data).show(onView: self.customView)
        }
    }
}

// MARK: - SearchResultsErrorFooterViewDelegate

extension SearchResultsController: SearchResultsErrorFooterViewDelegate {
    func refreshButtonClicked() {
        loadMoreData()
    }
}
