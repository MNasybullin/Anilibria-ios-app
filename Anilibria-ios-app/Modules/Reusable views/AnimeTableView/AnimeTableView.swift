//
//  AnimeTableView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.03.2023.
//

import Foundation
import UIKit
import SkeletonView

protocol AnimeTableViewDelegate: AnyObject {
    func getData(after: Int)
    func getImage(forIndexPath indexPath: IndexPath)
}

final class AnimeTableView: UITableView {
    weak var animeTableViewDelegate: AnimeTableViewDelegate?
    
    private let cellIdentifier = "AnimeCell"
    private let footerIdentifier = "AnimeFooter"
    
    private var heightForRow: CGFloat
    private var isLoadingMoreData: Bool = false
    private var needLoadMoreData: Bool
    
    private var footerView: AnimeTableFooterView = AnimeTableFooterView()
    
    private var data: [AnimeTableViewModel]?
    
    init(heightForRow: CGFloat, needLoadMoreData: Bool = true) {
        self.heightForRow = heightForRow
        self.needLoadMoreData = needLoadMoreData
        super.init(frame: .zero, style: .plain)
        
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        backgroundColor = .systemBackground
        
        register(AnimeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        delegate = self
        dataSource = self
        
        isSkeletonable = true
    }
    
    private func toggleFooterView() {
        DispatchQueue.main.async {
            if self.tableFooterView == nil {
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
    
    func update(_ data: [AnimeTableViewModel]) {
        self.data = data
        toggleSkeletonView()
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func addMore(_ data: [AnimeTableViewModel], needLoadMoreData: Bool) {
        DispatchQueue.main.async {
            self.isLoadingMoreData = false
            self.toggleFooterView()
            data.forEach { item in
                self.data?.append(item)
            }
            self.needLoadMoreData = needLoadMoreData
            self.reloadData()
        }
    }
    
    func update(_ image: UIImage, for indexPath: IndexPath) {
        data?[indexPath.row].image = image
        data?[indexPath.row].imageIsLoading = false
        DispatchQueue.main.async {
            self.reconfigureRows(at: [indexPath])
        }
    }
    
    private func toggleSkeletonView() {
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
extension AnimeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped")
    }
}

// MARK: - UITableViewDataSource
extension AnimeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AnimeTableViewCell else {
            fatalError("Cell is doesn`t AnimeTableViewCell")
        }
        guard data != nil else {
            if sk.isSkeletonActive == false {
                showAnimatedSkeleton()
                animeTableViewDelegate?.getData(after: 0)
            }
            return cell
        }
        let index = indexPath.row
        
        cell.ruNameLabel.text = data?[index].ruName
        cell.engNameLabel.text = data?[index].engName
        cell.descriptionLabel.text = data?[index].description
        if index == data!.count - 6 {
            loadMoreData()
        }
        guard let image = data?[index].image else {
            if data?[index].imageIsLoading == true {
                return cell
            }
            data?[index].imageIsLoading = true
            cell.animeImageView.showAnimatedSkeleton()
            animeTableViewDelegate?.getImage(forIndexPath: indexPath)
            return cell
        }
        if cell.animeImageView.sk.isSkeletonActive == true {
            cell.animeImageView.hideSkeleton(reloadDataAfter: false)
        }
        cell.animeImageView.image = image
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
        animeTableViewDelegate?.getData(after: data.count)
    }
}

// MARK: - SkeletonTableViewDataSource
extension AnimeTableView: SkeletonTableViewDataSource {
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
struct AnimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            AnimeTableView(heightForRow: 150)
        }
    }
}

#endif
