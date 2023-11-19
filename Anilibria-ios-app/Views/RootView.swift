//
//  RootView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.10.2023.
//

import UIKit

final class RootView: UIView {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let tabBarView: UIView
    private lazy var networkStatusView = NetworkStatusView()
    
    init(tabBarView: UIView) {
        self.tabBarView = tabBarView
        super.init(frame: .zero)
        
        configureView()
        configureNetworkStatusView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension RootView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureNetworkStatusView() {
        networkStatusView.isHidden = NetworkMonitor.shared.isConnected
    }
    
    func configureLayout() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(tabBarView)
        stackView.addArrangedSubview(networkStatusView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}

// MARK: - Internal methods

extension RootView {
    func updateView(status isConnected: Bool) {
        networkStatusView.isNetworkActive = isConnected
        
        let delay: TimeInterval = isConnected == true ? 3 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.allowUserInteraction]) {
                self.networkStatusView.isHidden = isConnected
                self.layoutIfNeeded()
            }
        }
    }
    
    func showFlashNetworkActivityView() {
        let color = self.networkStatusView.backgroundColor
        UIView.animate(withDuration: 0.5, 
                       delay: 0,
                       options: [.allowUserInteraction]) {
            self.networkStatusView.backgroundColor = .systemGray
        } completion: { _ in
            UIView.animate(withDuration: 0.5, 
                           delay: 0,
                           options: [.allowUserInteraction]) {
                self.networkStatusView.backgroundColor = color
            }
        }
    }
}
