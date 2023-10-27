//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit
import SkeletonView

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    typealias Section = HomeView.Section
    
    weak var navigator: HomeNavigator?
    
    private var data: [[AnimePosterItem]] = .init(repeating: [], count: 2)
    private lazy var models: [HomeModelInput] = {
        let todayModel = HomeTodayModel()
        todayModel.output = self
        todayModel.homeModelOutput = self
        
        let updatesModel = HomeUpdatesModel()
        updatesModel.output = self
        updatesModel.homeModelOutput = self
        return [todayModel, updatesModel]
    }()
    
    override func loadView() {
        view = HomeView(collectionViewDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        
        customView.showSkeletonCollectionView()
        requestInitialData()
    }
}

// MARK: - Private methods

private extension HomeController {
    // MARK: Configure NavigationBar
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func requestInitialData() {
        models.forEach {
            $0.requestData()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeController: UICollectionViewDelegate {
    // selected cell
}

// MARK: - UICollectionViewDataSource

extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier, for: indexPath) as? HomeHeaderSupplementaryView else {
            fatalError("Header is not HomeHeaderSupplementaryView")
        }
        
        switch indexPath.section {
            case Section.today.rawValue:
                header.configureView(
                    titleLabelText: Strings.HomeModule.Title.today,
                    titleButtonText: Strings.HomeModule.ButtonTitle.allDays)
                header.addButtonTarget(self, action: #selector(self.todayHeaderButtonTapped))
            case Section.updates.rawValue:
                header.configureView(
                    titleLabelText: Strings.HomeModule.Title.updates,
                    titleButtonText: nil)
            default:
                fatalError("Section is not found")
        }
        return header
    }
    
    // For Skeleton
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        data.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items: Int
        if data[section].isEmpty {
            items = 5
        } else {
            items = data[section].count
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimePosterCollectionViewCell.reuseIdentifier, for: indexPath) as? AnimePosterCollectionViewCell else {
            fatalError("Can`t create new cell")
        }
        let section = indexPath.section
        let row = indexPath.row
        guard data[section].isEmpty == false else {
            cell.configureCell(model: AnimePosterItem.getSkeletonInitialData())
            return cell
        }
        let item = data[section][row]
        if item.image == nil {
            models[section].requestImage(from: item, indexPath: indexPath)
        }
        cell.configureCell(model: item)
        return cell
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension HomeController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return HomeHeaderSupplementaryView.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return AnimePosterCollectionViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension HomeController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let section = indexPath.section
            let row = indexPath.row
            guard data[section].isEmpty == false, 
                    data[section][row].image == nil else { return }
            let item = data[section][row]
            models[section].requestImage(from: item, indexPath: indexPath)
        }
    }
}

// MARK: - HomeModelOutput

extension HomeController: HomeModelOutput {
    func refreshData(items: [AnimePosterItem], section: HomeView.Section) {
        data[section.rawValue] = items
        DispatchQueue.main.async {
            self.customView.reloadSection(numberOfSection: section.rawValue)
            self.customView.refreshControlEndRefreshing()
        }
    }
    
    func updateData(items: [AnimePosterItem], section: HomeView.Section) {
        data[section.rawValue] = items
        DispatchQueue.main.async {
            self.customView.hideSkeletonCollectionView()
            self.customView.reloadData()
        }
    }
    
    func failedRefreshData(error: Error) {
        DispatchQueue.main.async {
            self.customView.refreshControlEndRefreshing()
        }
    }
}

// MARK: - AnimePosterModelOutput

extension HomeController: AnimePosterModelOutput {
    func updateImage(for item: AnimePosterItem, image: UIImage, indexPath: IndexPath) {
        data[indexPath.section][indexPath.row].image = image
        DispatchQueue.main.async {
            self.customView.reconfigureItems(at: [indexPath])
        }
    }
    
    func failedRequestImage(error: Error) {
        print(error)
    }
}

// MARK: - HomeViewOutput

extension HomeController: HomeViewOutput {
    func handleRefreshControl() {
        guard NetworkMonitor.shared.isConnected == true else {
            MainNavigator.shared.rootViewController.showFlashNetworkActivityView()
            customView.refreshControlEndRefreshing()
            return
        }
        guard models[Section.today.rawValue].isDataTaskLoading == false && models[Section.updates.rawValue].isDataTaskLoading == false else {
            customView.refreshControlEndRefreshing()
            return
        }
        models.forEach { $0.refreshData() }
    }
}

// MARK: - Target

extension HomeController {
    @objc func todayHeaderButtonTapped() {
        navigator?.show(.schedule)
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
