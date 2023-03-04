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
    
    private var networkStatusView: NetworkStatusView = {
        let networkStatusView = NetworkStatusView(isNetworkActive: false)
        networkStatusView.translatesAutoresizingMaskIntoConstraints = false
        return networkStatusView
    }()
    
    private let networkActivityViewHeight: CGFloat = NetworkStatusView.labelFont.lineHeight
    
    private var isHiddenBottomBar: Bool = true {
        didSet {
            if isHiddenBottomBar {
                networkActivityViewHeightConstraint.constant = 0
                updateView(withDelay: 3)
            } else {
                networkActivityViewHeightConstraint.constant = (safeAreaInsetsBottomHeight ?? 0) + networkActivityViewHeight
                updateView()
            }
        }
    }
    
    private var networkActivityViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        networkStatusViewConfigure()
        tabBarConfigure()
    }
        
    private func networkStatusViewConfigure() {
        view.addSubview(networkStatusView)
        NSLayoutConstraint.activate([
            networkStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkStatusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        networkActivityViewHeightConstraint = networkStatusView.heightAnchor.constraint(equalToConstant: 0)
        networkActivityViewHeightConstraint.isActive = true
    }
    
    private func tabBarConfigure() {
        addChild(tabBar)
        view.addSubview(tabBar.view)
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.view.bottomAnchor.constraint(equalTo: networkStatusView.topAnchor)
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
        
    public func showNetworkActivityView() {
        if isHiddenBottomBar == true {
            networkStatusView.isNetworkActive = false
            isHiddenBottomBar = false
        }
    }
    
    public func hideNetworkActivityView() {
        if isHiddenBottomBar == false {
            networkStatusView.isNetworkActive = true
            isHiddenBottomBar = true
        }
    }
    
    public func showFlashNetworkActivityView() {
        if isHiddenBottomBar == false {
            DispatchQueue.main.async {
                let color = self.networkStatusView.backgroundColor
                UIView.animate(withDuration: 0.5, animations: {
                    self.networkStatusView.backgroundColor = .systemGray
                }, completion: {_ in
                    UIView.animate(withDuration: 0.5) {
                        self.networkStatusView.backgroundColor = color
                    }
                })
            }
        }
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            RootViewController.shared
        }
    }
}

#endif
