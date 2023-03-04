//
//  NetworkStatusView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.02.2023.
//

import UIKit

final class NetworkStatusView: UIView {
    static let labelFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = labelFont
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isNetworkActive: Bool! {
        didSet {
            viewConfigure()
        }
    }
    
    init(isNetworkActive: Bool) {
        super.init(frame: .zero)
        self.isNetworkActive = isNetworkActive
        
        addSubview(titleLabel)
        titleLabelConstraints()
        
        viewConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func titleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: NetworkStatusView.labelFont.lineHeight)
        ])
    }
    
    private func viewConfigure() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0) {
                if self.isNetworkActive {
                    self.backgroundColor = UIColor(asset: Asset.Colors.green)
                    self.titleLabel.text = Strings.NetworkStatusView.connectionRestored
                } else {
                    self.backgroundColor = UIColor(asset: Asset.Colors.red)
                    self.titleLabel.text = Strings.NetworkStatusView.noConnection
                }
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
            NetworkStatusView(isNetworkActive: false)
        }
    }
}

#endif
