//
//  NetworkStatusView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.02.2023.
//

import UIKit

final class NetworkStatusView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    var isNetworkActive: Bool = false {
        didSet {
            configureView()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureView() {
        DispatchQueue.main.async {
            if self.isNetworkActive {
                UIView.animate(withDuration: 1, delay: 0) {
                    self.backgroundColor = UIColor.myGreen
                    self.titleLabel.text = Strings.NetworkStatusView.connectionRestored
                }
            } else {
                self.backgroundColor = UIColor.myRed
                self.titleLabel.text = Strings.NetworkStatusView.noConnection
            }
        }
    }
}
