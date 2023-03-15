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
    func getData(after: Int)
    func getImage(forIndexPath indexPath: IndexPath)
}

final class SearchResultsTableView: UITableView {
    weak var searchResultsTableViewDelegate: SearchResultsTableViewDelegate?
    
    private let cellIdentifier = "SearchResultsCell"
    private let headerIdentifier = "SearchResultsHeader"
    private let footerIdentifier = "SearchResultsFooter"
    
    private var heightForRow: CGFloat
    private var isLoadingMoreData: Bool = false
    private var needLoadMoreData: Bool = true
    
    private var headerView: SearchResultsTableHeaderView = SearchResultsTableHeaderView()
    private var footerView: SearchResultsTableFooterView = SearchResultsTableFooterView()
    
    private var data: [SearchResultsTableViewModel]?
    
    init(heightForRow: CGFloat) {
        self.heightForRow = heightForRow
        super.init(frame: .zero, style: .plain)
        backgroundColor = .systemBackground
        
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        register(SearchResultsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        delegate = self
        dataSource = self
        
        isSkeletonable = true
    }
    
    private func toggleHeaderView() {
        DispatchQueue.main.async {
            self.beginUpdates()
            if self.data?.count == 0 {
                self.tableHeaderView = self.headerView
            } else {
                self.tableHeaderView = nil
            }
            self.endUpdates()
        }
    }
    
    private func toggleFooterView() {
        DispatchQueue.main.async {
            if self.isLoadingMoreData == true {
                self.footerView.activityIndicatorView.startAnimating()
                self.tableFooterView = self.footerView
            } else {
                self.footerView.activityIndicatorView.stopAnimating()
                self.beginUpdates()
                self.tableFooterView = nil
                self.endUpdates()
            }
        }
    }
    
    func deleteData() {
        DispatchQueue.main.async {
            self.data = nil
            self.needLoadMoreData = true
            self.isLoadingMoreData = false
            self.toggleHeaderView()
            self.toggleFooterView()
            self.reloadData()
        }
    }
    
    func update(_ data: [SearchResultsTableViewModel]) {
        DispatchQueue.main.async {
            self.data = data
            self.toggleHeaderView()
            self.toggleSkeletonView()
            self.reloadData()
        }
    }
    
    func addMore(_ data: [SearchResultsTableViewModel], needLoadMoreData: Bool) {
        DispatchQueue.main.async {
            self.isLoadingMoreData = false
            self.toggleFooterView()
            data.forEach { self.data?.append($0) }
            self.needLoadMoreData = needLoadMoreData
            self.reloadData()
        }
    }
    
    func update(_ image: UIImage, for indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.data?[indexPath.row].image = image
            self.data?[indexPath.row].imageIsLoading = false
            self.reconfigureRows(at: [indexPath])
        }
    }
    
    func toggleSkeletonView() {
        DispatchQueue.main.async {
            if self.data == nil,
                self.sk.isSkeletonActive == false {
                self.showAnimatedSkeleton()
            } else if self.sk.isSkeletonActive == true {
                self.hideSkeleton(reloadDataAfter: false)
            }
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
        print("tapped")
    }
}

// MARK: - UITableViewDataSource
extension SearchResultsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultsTableViewCell else {
            fatalError("Cell is doesn`t AnimeTableViewCell")
        }
        guard data != nil else {
            return cell
        }
        let index = indexPath.row
        
        cell.ruNameLabel.text = data?[index].ruName
        cell.engNameLabel.text = data?[index].engName
        cell.descriptionLabel.text = data?[index].description
        if index == data!.count - 2 {
            loadMoreData()
        }
        if data?[index].imageIsLoading == true {
            return cell
        }
        guard let image = data?[index].image else {
            data?[index].imageIsLoading = true
            cell.animeImageView.showAnimatedSkeleton()
            searchResultsTableViewDelegate?.getImage(forIndexPath: indexPath)
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
                isLoadingMoreData == false,
                let data = data else {
            return
        }
        isLoadingMoreData = true
        toggleFooterView()
        searchResultsTableViewDelegate?.getData(after: data.count)
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
