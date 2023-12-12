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
    
    private lazy var dataExpiredDate: Date = getExpiredDate()
    
    override func loadView() {
        view = HomeView(delegate: self, collectionViewDelegate: contentController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        requestData()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard dataIsExpired() == true else {
            return
        }
        customView.programaticallyBeginRefreshing()
    }
}

// MARK: - Private methods

private extension HomeController {
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func requestData() {
        contentController.requestInitialData()
    }
    
    func getExpiredDate() -> Date {
        var date = Date()
        let minute: Double = 60
        date.addTimeInterval(5 * minute)
        return date
    }
    
    func dataIsExpired() -> Bool {
        return Date().compare(dataExpiredDate) == .orderedDescending
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

// swiftlint:disable force_cast
extension HomeController: HomeContentControllerDelegate {
    func didSelectItem(_ rawData: Any, image: UIImage?, section: HomeView.Section) {
        switch section {
            case .today, .updates:
                navigator?.show(.anime(data: rawData as! TitleAPIModel, image: image))
            case .youtube:
                let data = rawData as! YouTubeAPIModel
                let urlString = NetworkConstants.youTubeWatchURL + data.youtubeId
                guard let url = URL(string: urlString) else { return }
                UIApplication.shared.open(url)
        }
    }
// swiftlint:enable force_cast
    
    func todayHeaderButtonTapped() {
        navigator?.show(.schedule)
    }
    
    func youTubeHeaderButtonTapped(data: [HomePosterItem], rawData: [YouTubeAPIModel]) {
        navigator?.show(.youTube(data: data, rawData: rawData))
    }
    
    func refreshControlEndRefreshing() {
        customView.refreshControlEndRefreshing()
    }
    
    func showSkeletonCollectionView() {
        customView.showSkeletonCollectionView()
    }
    
    func hideSkeletonCollectionView() {
        customView.hideSkeletonCollectionView()
    }
    
    func reloadSection(numberOfSection: Int) {
        customView.reloadSection(numberOfSection: numberOfSection)
        dataExpiredDate = getExpiredDate()
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
