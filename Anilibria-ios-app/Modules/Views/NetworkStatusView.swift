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
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var isNetworkActive: Bool = false {
        didSet {
            viewConfigure()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        titleLabelConstraints()
        viewConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func viewConfigure() {
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

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct NetworkStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            NetworkStatusView()
        }
    }
}

#endif
