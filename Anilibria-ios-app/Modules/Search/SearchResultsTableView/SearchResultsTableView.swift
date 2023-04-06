//
//  SearchResultsTableView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.03.2023.
//

import Foundation
import UIKit
import SkeletonView

protocol SearchResultsTableViewDelegate: AnyObject {
    func cellClicked(at indexPath: IndexPath)
    func getData(after: Int)
    func getImage(forIndexPath indexPath: IndexPath)
    func dismissKeyboard()
}

final class SearchResultsTableView: UITableView {
    weak var searchResultsTableViewDelegate: SearchResultsTableViewDelegate?
    
    private let cellIdentifier = "SearchResultsCell"
    
    private var heightForRow: CGFloat
    private var isLoadingMoreData: Bool = false {
        didSet { toggleFooterView() }
    }
    private var needLoadMoreData: Bool = true
    
    private var headerView = SearchResultsTableHeaderView()
    private var footerView = SearchResultsTableFooterView()
    private lazy var errorFooterView: SearchResultsTableErrorFooterView = {
        let view = SearchResultsTableErrorFooterView()
        view.delegate = self
        return view
    }()
    
    private var data = [SearchResultsModel]()
    
    init(heightForRow: CGFloat) {
        self.heightForRow = heightForRow
        super.init(frame: .zero, style: .plain)
        backgroundColor = .systemBackground
        
        configureTableView()
        configureKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        register(SearchResultsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        delegate = self
        dataSource = self
        prefetchDataSource = self
        
        isSkeletonable = true
    }
    
    private func configureKeyboard() {
        keyboardDismissMode = .onDrag
    }
    
    private func showHeaderView() {
        DispatchQueue.main.async {
            self.beginUpdates()
            self.tableHeaderView = self.headerView
            self.endUpdates()
        }
    }
    
    private func hideHeaderView() {
        DispatchQueue.main.async {
            self.beginUpdates()
            self.tableHeaderView = nil
            self.endUpdates()
        }
    }
    
    private func toggleFooterView() {
        DispatchQueue.main.async {
            self.beginUpdates()
            if self.isLoadingMoreData == true {
                self.footerView.activityIndicatorView.startAnimating()
                self.tableFooterView = self.footerView
            } else {
                self.footerView.activityIndicatorView.stopAnimating()
                self.tableFooterView = nil
            }
            self.endUpdates()
        }
    }
    
    func showErrorFooterView(with message: String) {
        DispatchQueue.main.async {
            self.beginUpdates()
            self.errorFooterView.title.text = message
            self.tableFooterView = self.errorFooterView
            self.endUpdates()
        }
    }
    
    func deleteData() {
        DispatchQueue.main.async {
            self.data.removeAll()
            self.needLoadMoreData = true
            self.isLoadingMoreData = false
            self.hideHeaderView()
            self.reloadData()
        }
    }
    
    func update(_ newData: [SearchResultsModel]) {
        DispatchQueue.main.async {
            self.data.append(contentsOf: newData)
            if newData.isEmpty {
                self.showHeaderView()
            }
            self.hideSkeleton(reloadDataAfter: false)
            self.reloadData()
        }
    }
    
    func addMore(_ newData: [SearchResultsModel], needLoadMoreData: Bool) {
        DispatchQueue.main.async {
            self.beginUpdates()
            var indexPaths: [IndexPath] = []
            for row in (self.data.count..<(self.data.count + newData.count)) {
                indexPaths.append(IndexPath(row: row, section: 0))
            }
            self.data.append(contentsOf: newData)
            self.isLoadingMoreData = false
            self.needLoadMoreData = needLoadMoreData
            self.insertRows(at: indexPaths, with: .fade)
            self.endUpdates()
        }
    }
    
    func update(_ image: UIImage?, for indexPath: IndexPath) {
        if image == nil {
            self.data[indexPath.row].imageIsLoading = false
            return
        }
        DispatchQueue.main.async {
            self.beginUpdates()
            self.data[indexPath.row].image = image
            self.data[indexPath.row].imageIsLoading = false
            self.reconfigureRows(at: [indexPath])
            self.endUpdates()
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchResultsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchResultsTableViewDelegate?.dismissKeyboard()
        searchResultsTableViewDelegate?.cellClicked(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension SearchResultsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultsTableViewCell else {
            fatalError("Cell is doesn`t AnimeTableViewCell")
        }
        let index = indexPath.row
        if data.isEmpty {
            return cell
        }
        
        cell.ruNameLabel.text = data[index].ruName
        cell.engNameLabel.text = data[index].engName
        cell.descriptionLabel.text = data[index].description
        cell.animeImageView.image = nil
        
        if index == data.count - 4 {
            loadMoreData()
        }
        
        guard let image = data[index].image else {
            if data[index].imageIsLoading == false && NetworkMonitor.shared.isConnected == true {
                data[index].imageIsLoading = true
                searchResultsTableViewDelegate?.getImage(forIndexPath: indexPath)
            }
            if cell.animeImageView.sk.isSkeletonActive == false {
                cell.animeImageView.showAnimatedSkeleton()
            }
            return cell
        }
        
        cell.animeImageView.image = image
        if cell.animeImageView.sk.isSkeletonActive == true {
            cell.animeImageView.hideSkeleton(reloadDataAfter: false)
        }
        return cell
    }
    
    func loadMoreData() {
        guard needLoadMoreData == true,
                isLoadingMoreData == false else {
            return
        }
        isLoadingMoreData = true
        toggleFooterView()
        searchResultsTableViewDelegate?.getData(after: data.count)
    }
}

extension SearchResultsTableView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if data[indexPath.row].image == nil && data[indexPath.row].imageIsLoading == false && NetworkMonitor.shared.isConnected == true {
                data[indexPath.row].imageIsLoading = true
                searchResultsTableViewDelegate?.getImage(forIndexPath: indexPath)
            }
        }
    }
}

// MARK: - SearchResultsTableErrorFooterViewDelegate
extension SearchResultsTableView: SearchResultsTableErrorFooterViewDelegate {
    func refreshButtonClicked() {
        isLoadingMoreData = false
        loadMoreData()
    }
}

// MARK: - SkeletonTableViewDataSource
extension SearchResultsTableView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct SearchResultsTableView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            SearchResultsTableView(heightForRow: 150)
        }
    }
}

#endif
