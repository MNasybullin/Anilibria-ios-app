//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    typealias Section = HomeView.Section
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimePosterItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnimePosterItem>
    
    weak var navigator: HomeNavigator?
    
    private lazy var homeTodayModel: HomeModelInput = {
        let model = HomeTodayModel()
        model.output = self
        model.homeModelOutput = self
        return model
    }()
    private lazy var homeUpdatesModel: HomeModelInput = {
        let model = HomeUpdatesModel()
        model.output = self
        model.homeModelOutput = self
        return model
    }()
    
    var dataSource: DataSource!
    private lazy var todayData: [AnimePosterItem] = AnimePosterItem.getSkeletonInitialData()
    private lazy var updatesData: [AnimePosterItem] = AnimePosterItem.getSkeletonInitialData()
    
    override func loadView() {
        view = HomeView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureNavigationBarAppearance()
        
        requestInitialData()
    }
}

// MARK: - Private methods

private extension HomeController {
    // MARK: Configure NavigationBar
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func configureNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    // MARK: Snapshot methods
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
    
    func update(data: [AnimePosterItem], from section: Section) {
        switch section {
            case .today:
                todayData = data
            case .updates:
                updatesData = data
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath) selected")
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension HomeController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            switch indexPath.section {
                case Section.today.rawValue:
                    guard todayData[indexPath.row].image == nil else { return }
                    homeTodayModel.requestImage(from: todayData[indexPath.row], indexPath: indexPath)
                case Section.updates.rawValue:
                    guard updatesData[indexPath.row].image == nil else { return }
                    homeUpdatesModel.requestImage(from: updatesData[indexPath.row], indexPath: indexPath)
                default:
                    fatalError("Section is not found")
            }
        }
    }
}

// MARK: - HomeModelOutput

extension HomeController: HomeModelOutput {
    func refreshData(items: [AnimePosterItem], section: HomeView.Section) {
        refreshSnapshot(for: section, data: items)
        DispatchQueue.main.async { [weak self] in
            self?.customView.refreshControlEndRefreshing()
            self?.customView.scrollToStart(section: section.rawValue)
        }
    }
    
    func updateData(items: [AnimePosterItem], section: HomeView.Section) {
        update(data: items, from: section)
        initialSnapshot()
    }
    
    func failedRefreshData(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.customView.refreshControlEndRefreshing()
        }
    }
}

// MARK: -

extension HomeController: AnimePosterModelOutput {
    func updateImage(for item: AnimePosterItem, image: UIImage, indexPath: IndexPath) {
        item.image = image
        self.reconfigureSnapshot(model: item)
    }
    
    func failedRequestImage(error: Error) {
        print(error)
    }
}

// MARK: - HomeViewOutput

extension HomeController: HomeViewOutput {
    func todayHeaderButtonTapped() {
        navigator?.show(.schedule)
    }
    
    func handleRefreshControl() {
        guard NetworkMonitor.shared.isConnected == true else {
            MainNavigator.shared.rootViewController.showFlashNetworkActivityView()
            customView.refreshControlEndRefreshing()
            return
        }
        guard homeTodayModel.isDataTaskLoading == false
                && homeUpdatesModel.isDataTaskLoading == false else {
            customView.refreshControlEndRefreshing()
            return
        }
        homeTodayModel.refreshData()
        homeUpdatesModel.refreshData()
    }
    
    func requestImage(for model: AnimePosterItem, indexPath: IndexPath) {
        switch indexPath.section {
            case Section.today.rawValue:
                homeTodayModel.requestImage(from: model, indexPath: indexPath)
            case Section.updates.rawValue:
                homeUpdatesModel.requestImage(from: model, indexPath: indexPath)
            default:
                fatalError("Section is not found")
        }
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
