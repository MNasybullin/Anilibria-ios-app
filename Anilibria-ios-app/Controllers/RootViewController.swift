//
//  RootViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.02.2023.
//

import UIKit
import Combine

final class RootViewController: UIViewController {
    private var stackView = UIStackView()
    private let tabBar: UITabBarController
    private var networkStatusView = NetworkStatusView()
        
    private var cancellable: AnyCancellable!
    
    // MARK: LifeCycle
    init(tabBarController: UITabBarController) {
        self.tabBar = tabBarController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureStackView()
        configureNetworkStatusView()
        configureLayout()
        subscribeToNetworkMonitor()
    }
}

// MARK: - Private methods

private extension RootViewController {
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureStackView() {
        stackView.axis = .vertical
    }
    
    func configureNetworkStatusView() {
        networkStatusView.isHidden = NetworkMonitor.shared.isConnected
    }
    
    func configureLayout() {
        view.addSubview(stackView)
        
        addChild(tabBar)
        stackView.addArrangedSubview(tabBar.view)
        tabBar.didMove(toParent: self)
        
        stackView.addArrangedSubview(networkStatusView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func subscribeToNetworkMonitor() {
        cancellable = NetworkMonitor.shared.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                self.updateView(status: isConnected)
            }
    }
    
    func updateView(status isConnected: Bool) {
        networkStatusView.isNetworkActive = isConnected
        
        let delay: TimeInterval = isConnected == true ? 3 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.3) {
                self.networkStatusView.isHidden = isConnected
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Internal methods

extension RootViewController {
    func showFlashNetworkActivityView() {
        guard NetworkMonitor.shared.isConnected == false else {
            return
        }
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
