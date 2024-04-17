//
//  RootViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.02.2023.
//

import UIKit
import Combine

final class RootViewController: UIViewController, HasCustomView {
    typealias CustomView = RootView
    
    private let tabBar: UITabBarController
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: LifeCycle
    init(tabBarController: UITabBarController) {
        self.tabBar = tabBarController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        addChild(tabBar)
        view = RootView(tabBarView: tabBar.view)
        tabBar.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNetworkMonitor()
    }
}

// MARK: - Private methods

private extension RootViewController {
    func subscribeToNetworkMonitor() {
        NetworkMonitor.shared.isConnectedPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.updateView(status: isConnected)
            }
            .store(in: &subscriptions)
    }
    
    func updateView(status isConnected: Bool) {
        customView.updateView(status: isConnected)
    }
}

// MARK: - Internal methods

extension RootViewController {
    func showFlashNetworkActivityView() {
        guard NetworkMonitor.shared.isConnected == false else {
            return
        }
        DispatchQueue.main.async {
            self.customView.showFlashNetworkActivityView()
        }
    }
    
    func selectTabBarItem(_ item: TabBarItemTags) {
        tabBar.selectedIndex = item.rawValue
    }
    
    func configureTabBarBadge(item: TabBarItemTags, badgeValue: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.tabBar.tabBar.items?[item.rawValue].badgeValue = badgeValue
        }
    }
}
