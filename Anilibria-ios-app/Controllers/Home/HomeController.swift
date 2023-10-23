//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit

protocol HomeControllerProtoocol: AnyObject {
    func refreshControlEndRefreshing()
}

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    
    weak var navigator: HomeNavigator?
    
    var contentController = HomeContentController()
    
    override func loadView() {
        view = HomeView()
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
        
        let cellProvider = contentController.configureCellProvider()
        let dataSource = customView.configureDataSource(cellProvider: cellProvider)
        contentController.configureDataSource(dataSource)
        
        customView.configureCollectionViewDelegate(contentController)
        customView.configurePrefetchDataSource(contentController)
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

extension HomeController: HomeControllerProtoocol {
    func refreshControlEndRefreshing() {
        customView.refreshControlEndRefreshing()
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
