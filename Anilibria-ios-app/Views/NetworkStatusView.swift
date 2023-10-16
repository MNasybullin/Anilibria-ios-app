//
//  NetworkStatusView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.02.2023.
//

import UIKit

final class NetworkStatusView: UIView {
    private var titleLabel = UILabel()
    
    var isNetworkActive: Bool = false {
        didSet {
            setupView()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        setupTitleLabel()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        titleLabelConstraints()
    }
    
    private func titleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupView() {
        DispatchQueue.main.async {
            if self.isNetworkActive {
                UIView.animate(withDuration: 1, delay: 0) {
                    self.backgroundColor = UIColor(asset: Asset.Colors.green)
                    self.titleLabel.text = Strings.NetworkStatusView.connectionRestored
                }
            } else {
                self.backgroundColor = UIColor(asset: Asset.Colors.red)
                self.titleLabel.text = Strings.NetworkStatusView.noConnection
            }
        }
    }
}
