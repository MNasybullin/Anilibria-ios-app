//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit

protocol HomeControllerInput: AnyObject {
    func refreshControlEndRefreshing()
    func scrollToStart(section: Int)
}

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    
    weak var navigator: HomeNavigator?
    
    var contentController = HomeContentController()
    
    override func loadView() {
        view = HomeView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureNavigationBarAppearance()
        configureHomeView()
        
        configureContentController()
    }
}

// MARK: - Private methods

private extension HomeController {
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func configureNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    func configureContentController() {
        contentController.homeController = self
        customView.configureDataSourceAndDelegate(contentController)
    }
    
    func configureHomeView() {
        customView.addRefreshControllTarget(self, action: #selector(handleRefreshControl))
    }
    
    @objc func handleRefreshControl() {
        guard NetworkMonitor.shared.isConnected == true else {
            MainNavigator.shared.rootViewController.showFlashNetworkActivityView()
            customView.refreshControlEndRefreshing()
            return
        }
        contentController.refreshData()
    }
}

// MARK: - HomeControllerProtoocol

extension HomeController: HomeControllerInput {
    func refreshControlEndRefreshing() {
        customView.refreshControlEndRefreshing()
    }
    
    func scrollToStart(section: Int) {
        customView.scrollToStart(section: section)
    }
}

// MARK: - HomeViewOutput

extension HomeController: HomeViewOutput {
    func requestImage(for item: AnimePosterItem, indexPath: IndexPath) {
        contentController.requestImage(for: item, indexPath: indexPath)
    }
    
    func todayHeaderButtonTapped() {
        navigator?.show(.schedule)
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
