//
//  ProfileView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

final class ProfileView: UIView {
    let layout = ProfileCollectionViewLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout.createLayout())
    
    private lazy var currentWindow: UIWindow? = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window
    }()
    
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

private extension ProfileView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupCollectionView() {
        collectionView.register(AppUpdateCollectionViewCell.self, forCellWithReuseIdentifier: AppUpdateCollectionViewCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.reuseIdentifier)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: UICollectionViewListCell.reuseIdentifier)
        
        collectionView.keyboardDismissMode = .onDrag
    }
    
    func setupLayout() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: -(currentWindow?.safeAreaInsets.top ?? 0)),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
