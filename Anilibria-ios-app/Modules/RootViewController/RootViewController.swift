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
                updateView(withDelay: 3)
            } else {
                heightConstraint.constant = (safeAreaInsetsBottomHeight ?? 0) + networkActivityViewHeight
                updateView()
            }
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
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {_ in
//            RootViewController.shared.showFlashInNetworkActivityView()
//        }
//        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) {_ in
//            RootViewController.shared.hideNetworkActivityView()
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
    
    private func updateView(withDelay delay: TimeInterval = 0) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: delay) {
                self.view.layoutIfNeeded()
            }
        }
    }
        
    func showNetworkActivityView() {
        networkActivityView.networkIsActive = false
        hideBottomBar = false
    }
    
    func hideNetworkActivityView() {
        networkActivityView.networkIsActive = true
        hideBottomBar = true
    }
    
    func showFlashInNetworkActivityView() {
        DispatchQueue.main.async {
            let color = self.networkActivityView.backgroundColor
            UIView.animate(withDuration: 0.5, animations: {
                self.networkActivityView.backgroundColor = .systemGray
            }, completion: {_ in
                UIView.animate(withDuration: 0.5) {
                    self.networkActivityView.backgroundColor = color
                }
            })
        }
    }
}
