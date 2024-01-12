//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit
import Combine

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    weak var navigator: HomeNavigator?
    
    private lazy var contentController = HomeContentController(delegate: self)
    
    private let expiredDateManager = ExpiredDateManager(expireTimeInMinutes: 5)
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func loadView() {
        view = HomeView(delegate: self, collectionViewDelegate: contentController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        requestData()
        expiredDateManager.start()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notificationCenterSubscription()
        
        guard expiredDateManager.isExpired() == true else {
            return
        }
        customView.programaticallyBeginRefreshing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        subscriptions.removeAll()
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
    
    func notificationCenterSubscription() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                guard self?.expiredDateManager.isExpired() == true else { return }
                self?.customView.programaticallyBeginRefreshing()
            }
            .store(in: &subscriptions)
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
        expiredDateManager.start()
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
