//
//  HomeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.10.2023.
//

import UIKit

final class HomeContentController: NSObject {
    typealias Section = HomeView.Section
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimePosterItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnimePosterItem>
    
    private lazy var homeTodayModel: HomeModelInput = {
        let model = HomeTodayModel()
        model.output = self
        return model
    }()
    private lazy var homeUpdatesModel: HomeModelInput = {
        let model = HomeUpdatesModel()
        model.output = self
        return model
    }()
    
    private var dataSource: DataSource!
    
    private lazy var todayData: [AnimePosterItem] = AnimePosterItem.getSkeletonInitialData()
    private lazy var updatesData: [AnimePosterItem] = AnimePosterItem.getSkeletonInitialData()
    
    weak var homeController: HomeControllerInput?
    
    override init() {
        super.init()
        
        requestInitialData()
    }
}

// MARK: - Private methods

private extension HomeContentController {
    func requestInitialData() {
        homeTodayModel.requestData()
        homeUpdatesModel.requestData()
    }
    
    func initialSnapshot() {
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([.today, .updates])
            snapshot.appendItems(self.todayData, toSection: .today)
            snapshot.appendItems(self.updatesData, toSection: .updates)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
        
    func refreshSnapshot(for section: Section, data: [AnimePosterItem]) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            switch section {
                case .today:
                    snapshot.deleteItems(self.todayData)
                    self.todayData = data
                    snapshot.appendItems(self.todayData, toSection: .today)
                case .updates:
                    snapshot.deleteItems(self.updatesData)
                    self.updatesData = data
                    snapshot.appendItems(self.updatesData, toSection: .updates)
            }
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func reconfigureSnapshot(model: AnimePosterItem) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            guard snapshot.indexOfItem(model) != nil else {
                return
            }
            snapshot.reconfigureItems([model])
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func requestImage(for model: AnimePosterItem, indexPath: IndexPath) {
        switch indexPath.section {
            case Section.today.rawValue:
                homeTodayModel.requestImage(from: model)
            case Section.updates.rawValue:
                homeUpdatesModel.requestImage(from: model)
            default:
                fatalError("Section is not found")
        }
    }
    
    func update(data: [AnimePosterItem], from section: Section) {
        switch section {
            case .today:
                todayData = data
            case .updates:
                updatesData = data
        }
    }
}

// MARK: - Internal methods

extension HomeContentController {
    func configureCellProvider() -> DataSource.CellProvider {
        let cellProvider: DataSource.CellProvider = { (collectionView, indexPath, model) in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimePosterCollectionViewCell.reuseIdentifier,
                for: indexPath) as? AnimePosterCollectionViewCell else {
                fatalError("Can`t create new cell")
            }
            if model.image == nil {
                self.requestImage(for: model, indexPath: indexPath)
            }
            cell.configureCell(model: model)
            return cell
        }
        return cellProvider
    }
    
    func configureDataSource(_ dataSource: DataSource) {
        self.dataSource = dataSource
        initialSnapshot()
    }
    
    func refreshData() {
        guard homeTodayModel.isDataTaskLoading == false
                && homeUpdatesModel.isDataTaskLoading == false else {
            DispatchQueue.main.async { [weak self] in
                self?.homeController?.refreshControlEndRefreshing()
            }
            return
        }
        homeTodayModel.refreshData()
        homeUpdatesModel.refreshData()
    }
}

// MARK: - UICollectionViewDelegate

extension HomeContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath) selected")
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension HomeContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            switch indexPath.section {
                case Section.today.rawValue:
                    guard todayData[indexPath.row].image == nil else { return }
                    homeTodayModel.requestImage(from: todayData[indexPath.row])
                case Section.updates.rawValue:
                    guard updatesData[indexPath.row].image == nil else { return }
                    homeUpdatesModel.requestImage(from: updatesData[indexPath.row])
                default:
                    fatalError("Section is not found")
            }
        }
    }
}

// MARK: - HomeModelOutput

extension HomeContentController: HomeModelOutput {
    func refreshData(items: [AnimePosterItem], section: HomeView.Section) {
        refreshSnapshot(for: section, data: items)
        DispatchQueue.main.async { [weak self] in
            self?.homeController?.refreshControlEndRefreshing()
            self?.homeController?.scrollToStart(section: section.rawValue)
        }
    }
    
    func updateData(items: [AnimePosterItem], section: HomeView.Section) {
        update(data: items, from: section)
        initialSnapshot()
    }
    
    func updateImage(for item: AnimePosterItem, image: UIImage) {
        item.image = image
        self.reconfigureSnapshot(model: item)
    }
    
    func failedRefreshData(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.homeController?.refreshControlEndRefreshing()
        }
    }
}
