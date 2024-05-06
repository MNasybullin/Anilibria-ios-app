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
            contentController.requestRefreshWatchingData()
            return
        }
        contentController.requestDataWithRefreshStatus()
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
                guard self?.expiredDateManager.isExpired() == true else {
                    self?.contentController.requestRefreshWatchingData()
                    return
                }
                self?.contentController.requestDataWithRefreshStatus()
                self?.expiredDateManager.start()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - HomeViewOutput

extension HomeController: HomeViewOutput {
    func handleRefreshControl() {
        if NetworkMonitor.shared.isConnected == false {
            MainNavigator.shared.rootViewController.showFlashNetworkActivityView()
        }
        contentController.requestDataWithRefreshStatus()
    }
    
    func refreshButtonDidTapped() {
        contentController.requestDataWithLoadingStatus()
    }
}

// MARK: - HomeContentControllerDelegate

extension HomeController: HomeContentControllerDelegate {
    func show(_ destination: HomeNavigator.Destination) {
        navigator?.show(destination)
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
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
