//
//  RootViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.02.2023.
//

import Foundation
import UIKit

final class RootViewController: UIViewController {
    static let shared: RootViewController = RootViewController()
    
    private var tabBar: (UITabBarController & TabBarViewProtocol) = {
        return TabBarRouter.start().entry
    }()
    
    var safeAreaInsetsBottomHeight: CGFloat?
    
    private var networkActivityView: NetworkStatusView = {
        let networkStatusView = NetworkStatusView(networkIsActive: false)
        networkStatusView.translatesAutoresizingMaskIntoConstraints = false
        return networkStatusView
    }()
    
    private let networkActivityViewHeight: CGFloat = NetworkStatusView.labelFont.lineHeight
    
    private var hideBottomBar: Bool = true {
        didSet {
            if hideBottomBar {
                heightConstraint.constant = 0
            } else {
                heightConstraint.constant = (safeAreaInsetsBottomHeight ?? 0) + networkActivityViewHeight
            }
            updateView()
        }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        networkActivityViewConfigure()
        heightConstraintConfigure()
        tabBarConfigure()

        // for testing
//        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) {_ in
//            RootViewController.shared.showNetworkActivityView()
//        }
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
//            RootViewController.shared.changeNetworkActivityStatusAndHide()
//        }
    }
        
    private func networkActivityViewConfigure() {
        view.addSubview(networkActivityView)
        NSLayoutConstraint.activate([
            networkActivityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkActivityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkActivityView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func heightConstraintConfigure() {
        heightConstraint = networkActivityView.heightAnchor.constraint(equalToConstant: (safeAreaInsetsBottomHeight ?? 0) + networkActivityViewHeight)
        heightConstraint.isActive = true
        if hideBottomBar {
            heightConstraint.constant = 0
        }
    }
    
    private func tabBarConfigure() {
        addChild(tabBar)
        view.addSubview(tabBar.view)
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.view.bottomAnchor.constraint(equalTo: networkActivityView.topAnchor)
        ])
        tabBar.didMove(toParent: self)
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Internal Methods
    
    public func showNetworkActivityView() {
        networkActivityView.networkIsActive = false
        hideBottomBar = false
    }
    
    func changeNetworkActivityStatusAndHide() {
        networkActivityView.networkIsActive = true
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {_ in
            self.hideBottomBar = true
        }
    }
}
