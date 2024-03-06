//
//  SettingsCollectionViewHeader.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsCollectionViewHeader: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SettingsCollectionViewHeader {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Internal methods

extension SettingsCollectionViewHeader {
    func setTitle(text: String?) {
        titleLabel.text = text
    }
}
