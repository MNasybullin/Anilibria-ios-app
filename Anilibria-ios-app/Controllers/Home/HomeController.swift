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
    
    private var contentController: HomeContentController!
    
    private let expiredDateManager = ExpiredDateManager(expireTimeInMinutes: 5)
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func loadView() {
        view = HomeView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        setupContentController()
        expiredDateManager.start()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notificationCenterSubscription()
        
        guard expiredDateManager.isExpired() == true else {
            return
        }
        customView.programaticallyBeginRefreshing()
        expiredDateManager.start()
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
    
    func setupContentController() {
        contentController = HomeContentController(customView: customView, delegate: self)
    }
    
    func notificationCenterSubscription() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                guard self?.expiredDateManager.isExpired() == true else { return }
                self?.customView.programaticallyBeginRefreshing()
                self?.expiredDateManager.start()
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

extension HomeController: HomeContentControllerDelegate {
    func didSelectTodayItem(_ rawData: TitleAPIModel?, image: UIImage?) {
        guard let rawData else { return }
        navigator?.show(.anime(data: rawData, image: image))
    }
    
    func didSelectWatchingItem(data: AnimeItem, currentPlaylist: Int) {
        navigator?.show(.videoPlayer(data: data, currentPlaylist: currentPlaylist))
    }
    
    func didSelectUpdatesItem(_ rawData: TitleAPIModel?, image: UIImage?) {
        guard let rawData else { return }
        navigator?.show(.anime(data: rawData, image: image))
    }
    
    func didSelectYoutubeItem(_ rawData: YouTubeAPIModel?) {
        guard let rawData else { return }
        let urlString = NetworkConstants.youTubeWatchURL + rawData.youtubeId
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func todayHeaderButtonTapped() {
        navigator?.show(.schedule)
    }
    
    func youTubeHeaderButtonTapped(data: [HomePosterItem], rawData: [YouTubeAPIModel]) {
        navigator?.show(.youTube(data: data, rawData: rawData))
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}

// MARK: - HasPosterCellAnimatedTransitioning

extension HomeController: HasPosterCellAnimatedTransitioning {
    var selectedCell: PosterCollectionViewCell? {
        contentController.selectedCell
    }
    
    var selectedCellImageViewSnapshot: UIView? {
        contentController.selectedCellImageViewSnapshot
    }
}
