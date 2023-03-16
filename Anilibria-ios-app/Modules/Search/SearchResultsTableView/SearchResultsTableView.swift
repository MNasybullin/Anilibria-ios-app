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
    private var isLoadingMoreData: Bool = false {
        didSet { toggleFooterView() }
    }
    private var needLoadMoreData: Bool = true
    
    private var headerView = SearchResultsTableHeaderView()
    private var footerView = SearchResultsTableFooterView()
    
    private var sectionData = [SearchResultsSectionsModel]()
    
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
            self.sectionData.removeAll()
            self.needLoadMoreData = true
            self.isLoadingMoreData = false
            self.hideHeaderView()
            self.reloadData()
        }
    }
    
    func update(_ data: [SearchResultsRowsModel]) {
        DispatchQueue.main.async {
            self.sectionData.append(SearchResultsSectionsModel(rowsData: data))
            if data.isEmpty {
                self.showHeaderView()
            }
            self.hideSkeleton(reloadDataAfter: false)
            self.reloadData()
        }
    }
    
    func addMore(_ data: [SearchResultsRowsModel], needLoadMoreData: Bool) {
        DispatchQueue.main.async {
            self.isLoadingMoreData = false
            self.sectionData.append(SearchResultsSectionsModel(rowsData: data))
            self.needLoadMoreData = needLoadMoreData
            self.insertSections(IndexSet(integer: self.sectionData.count - 1), with: .fade)
        }
    }
    
    func update(_ image: UIImage, for indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.sectionData[indexPath.section].rowsData?[indexPath.row].image = image
            self.sectionData[indexPath.section].rowsData?[indexPath.row].imageIsLoading = false
            self.reconfigureRows(at: [indexPath])
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
        return sectionData[section].rowsData?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultsTableViewCell else {
            fatalError("Cell is doesn`t AnimeTableViewCell")
        }
        let section = indexPath.section
        let row = indexPath.row
        guard let data = sectionData[section].rowsData?[row] else {
            return cell
        }
        
        cell.ruNameLabel.text = data.ruName
        cell.engNameLabel.text = data.engName
        cell.descriptionLabel.text = data.description
        
        if (section == sectionData.count - 1) &&
            (row == sectionData[section].rowsData!.count - 3) {
            loadMoreData(section: section)
        }

        guard let image = data.image else {
            if data.imageIsLoading == true {
                return cell
            }
            sectionData[section].rowsData?[row].imageIsLoading = true
            cell.animeImageView.image = UIImage(asset: Asset.Assets.blankImage)
            searchResultsTableViewDelegate?.getImage(forIndexPath: indexPath)
            return cell
        }
        cell.animeImageView.image = image
        return cell
    }
    
    func loadMoreData(section: Int) {
        guard needLoadMoreData == true,
                isLoadingMoreData == false,
              let data = sectionData[section].rowsData else {
            return
        }
        isLoadingMoreData = true
        toggleFooterView()
        searchResultsTableViewDelegate?.getData(after: data.count * (section + 1))
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
