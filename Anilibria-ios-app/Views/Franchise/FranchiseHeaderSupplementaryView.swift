//
//  FranchiseHeaderSupplementaryView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.01.2024.
//

import UIKit

final class FranchiseHeaderSupplementaryView: UICollectionReusableView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Skeleton"
        label.textColor = .label
        let size = UIFont.preferredFont(forTextStyle: .headline).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        label.isSkeletonable = true
        label.linesCornerRadius = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension FranchiseHeaderSupplementaryView {
    func setupView() {
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Internal methods

extension FranchiseHeaderSupplementaryView {
    func configureView(title: String) {
        titleLabel.text = title
    }
}
