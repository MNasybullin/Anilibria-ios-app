//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    
    weak var navigator: HomeNavigator?
    
    private lazy var contentController = HomeContentController(delegate: self)
    
    override func loadView() {
        view = HomeView(delegate: self, collectionViewDelegate: contentController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        requestData()
    }
}

// MARK: - Private methods

private extension HomeController {
    // MARK: Configure NavigationBar
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func requestData() {
        customView.showSkeletonCollectionView()
        contentController.requestInitialData()
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
        contentController.requestRefreshData()
    }
}

// MARK: - HomeContentControllerDelegate

extension HomeController: HomeContentControllerDelegate {
    func didSelectItem(_ rawData: [TitleAPIModel]) {
        guard rawData.isEmpty == false else {
            return
        }
//        print(rawData)
//        navigator?.show(.anime)
    }
    
    func todayHeaderButtonTapped() {
        navigator?.show(.schedule)
    }
    
    func refreshControlEndRefreshing() {
        customView.refreshControlEndRefreshing()
    }
    
    func hideSkeletonCollectionView() {
        customView.hideSkeletonCollectionView()
    }
    
    func reloadData() {
        customView.reloadData()
    }
    
    func reconfigureItems(at indexPaths: [IndexPath]) {
        customView.reconfigureItems(at: indexPaths)
    }
    
    func reloadSection(numberOfSection: Int) {
        customView.reloadSection(numberOfSection: numberOfSection)
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
