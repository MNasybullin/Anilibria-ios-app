//
//  HomeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.10.2023.
//

import UIKit

final class HomeContentController: NSObject {
    typealias ElementKind = HomeView.ElementKind
    typealias Section = HomeView.Section
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeModel>
    
    private var homeTodayModel: HomeModelController = HomeTodayModelController()
    private var homeUpdatesModel: HomeModelController = HomeUpdatesModelController()
    
    private var dataSource: DataSource!
    
    private var todayData: [HomeModel] = HomeModel.getSkeletonInitialData()
    private var updatesData: [HomeModel] = HomeModel.getSkeletonInitialData()
    
    weak var homeController: HomeControllerProtoocol?
    
    override init() {
        super.init()
        
        requestInitialData()
    }
}

// MARK: - Private methods

private extension HomeContentController {
    func configureSupplementaryViewDataSource() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == ElementKind.sectionHeader else { return nil }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier,
                for: indexPath) as? HomeHeaderSupplementaryView else {
                fatalError("Can`t create new header")
            }
            
            switch indexPath.section {
                case Section.today.rawValue:
                    headerView.configureView(
                        titleLabelText: Strings.HomeModule.Title.today,
                        titleButtonText: Strings.HomeModule.ButtonTitle.allDays)
                case Section.updates.rawValue:
                    headerView.configureView(
                        titleLabelText: Strings.HomeModule.Title.updates,
                        titleButtonText: nil)
                default:
                    fatalError("Section is not found")
            }
            return headerView
        }
    }
    
    func requestInitialData() {
        let completionBlock: HomeModelController.ResultDataBlock = { [weak self] result in
            switch result {
                case .success((let data, let section)):
                    self?.update(data: data, from: section)
                    self?.refreshSnapshot()
                case .failure(let error):
                    print(error)
            }
        }
        homeTodayModel.requestData(completionHanlder: completionBlock)
        homeUpdatesModel.requestData(completionHanlder: completionBlock)
    }
    
    func initialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.today, .updates])
        snapshot.appendItems(todayData, toSection: .today)
        snapshot.appendItems(updatesData, toSection: .updates)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
        
    func refreshSnapshot() {
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([.today, .updates])
            snapshot.appendItems(self.todayData, toSection: .today)
            snapshot.appendItems(self.updatesData, toSection: .updates)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func reconfigureSnapshot(model: HomeModel) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.reconfigureItems([model])
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func requestImage(for model: HomeModel, indexPath: IndexPath) {
        switch indexPath.section {
            case Section.today.rawValue:
                homeTodayModel.getImage(for: model) {
                    self.reconfigureSnapshot(model: $0)
                }
            case Section.updates.rawValue:
                homeUpdatesModel.getImage(for: model) {
                    self.reconfigureSnapshot(model: $0)
                }
            default:
                fatalError("Section is not found")
        }
    }
    
    func update(data: [HomeModel], from section: Section) {
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
                withReuseIdentifier: PosterCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PosterCollectionViewCell else {
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
        configureSupplementaryViewDataSource()
        initialSnapshot()
    }
    
    func refreshData() {
        if homeTodayModel.isDataTaskLoading || homeUpdatesModel.isDataTaskLoading {
            DispatchQueue.main.async { [weak self] in
                self?.homeController?.refreshControlEndRefreshing()
            }
            return
        }
        let completionBlock: HomeModelController.ResultDataBlock = { [weak self] result in
            switch result {
                case .success((let data, let section)):
                    self?.update(data: data, from: section)
                    self?.refreshSnapshot()
                case .failure(let error):
                    print(error)
            }
            DispatchQueue.main.async {
                self?.homeController?.refreshControlEndRefreshing()
            }
        }
        homeTodayModel.requestData(completionHanlder: completionBlock)
        homeUpdatesModel.requestData(completionHanlder: completionBlock)
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
                    homeTodayModel.getImage(for: todayData[indexPath.row]) {
                        self.reconfigureSnapshot(model: $0)
                    }
                case Section.updates.rawValue:
                    guard updatesData[indexPath.row].image == nil else { return }
                    homeUpdatesModel.getImage(for: updatesData[indexPath.row]) {
                        self.reconfigureSnapshot(model: $0)
                    }
                default:
                    fatalError("Section is not found")
            }
        }
    }
}
