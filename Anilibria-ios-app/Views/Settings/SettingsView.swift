//
//  SettingsView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsView: UIView {
    private let layout = SettingsCollectionViewLayout().createLayout()
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SettingsView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupCollectionView() {
        collectionView.register(SettingsAppearanceCell.self, forCellWithReuseIdentifier: SettingsAppearanceCell.reuseIdentifier)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: UICollectionViewListCell.reuseIdentifier)
        collectionView.register(SettingsCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingsCollectionViewHeader.reuseIdentifier)
    }
    
    func setupLayout() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
