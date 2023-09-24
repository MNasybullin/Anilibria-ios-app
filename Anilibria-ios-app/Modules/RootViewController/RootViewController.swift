//
//  RootViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.02.2023.
//

import Foundation
import UIKit
import Combine

final class RootViewController: UIViewController {
    static let shared: RootViewController = RootViewController()
    
    private var tabBar: (UITabBarController & TabBarViewProtocol) = {
        return TabBarRouter.start().entry
    }()
    
    private var networkStatusView = NetworkStatusView()
    
    private var isHiddenBottomBar: Bool = NetworkMonitor.shared.isConnected {
        didSet { updateView() }
    }
    
    private var networkStatusViewIsZeroHeightConstraint: NSLayoutConstraint!
    
    private var cancellable: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNetworkStatusView()
        configureTabBar()
        subscribeToNetworkMonitor()
        updateView()
    }
        
    private func configureNetworkStatusView() {
        view.addSubview(networkStatusView)
        
        networkStatusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            networkStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkStatusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        networkStatusViewIsZeroHeightConstraint = networkStatusView.heightAnchor.constraint(equalToConstant: 0)
        networkStatusViewIsZeroHeightConstraint.isActive = true
    }
    
    private func configureTabBar() {
        view.addSubview(tabBar.view)
        addChild(tabBar)
        
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.view.bottomAnchor.constraint(equalTo: networkStatusView.topAnchor)
        ])
        
        tabBar.didMove(toParent: self)
    }
    
    private func subscribeToNetworkMonitor() {
        cancellable = NetworkMonitor.shared.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                if isConnected == false {
                    self.showNetworkActivityView()
                } else {
                    self.hideNetworkActivityView()
                }
            }
    }
    
    private func updateView() {
        let delay: TimeInterval = isHiddenBottomBar == true ? 3 : 0

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.3) {
                self.networkStatusViewIsZeroHeightConstraint.isActive = self.isHiddenBottomBar
                self.view.layoutIfNeeded()
            }
        }
    }
        
    private func showNetworkActivityView() {
        guard isHiddenBottomBar == true else { return }
        networkStatusView.isNetworkActive = false
        isHiddenBottomBar = false
    }
    
    private func hideNetworkActivityView() {
        guard isHiddenBottomBar == false else { return }
        networkStatusView.isNetworkActive = true
        isHiddenBottomBar = true
    }
    
    public func showFlashNetworkActivityView() {
        guard NetworkMonitor.shared.isConnected == false else { return }
        showNetworkActivityView()
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

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct RootViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            RootViewController.shared
        }
    }
}

#endif
