//
//  YouTubeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.12.2023.
//

import UIKit
import SkeletonView

final class YouTubeView: UIView {
    enum Status {
        case normal
        case loadingMore
        case loadingMoreFail
    }
    
    private lazy var collectionViewLayout = YouTubeCollectionViewLayout()
    private (set) var collectionView: UICollectionView!
    
    var collectionViewDelegate: UICollectionViewDelegate? {
        get { collectionView.delegate }
        set { collectionView.delegate = newValue }
    }
    
    var collectionViewDataSource: UICollectionViewDataSource? {
        get { collectionView.dataSource }
        set { collectionView.dataSource = newValue }
    }
    
    var collectionViewDataSourcePrefetching: UICollectionViewDataSourcePrefetching? {
        get { collectionView.prefetchDataSource }
        set { collectionView.prefetchDataSource = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension YouTubeView {
    func setupCollectionView() {
        let layout = collectionViewLayout.createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            YouTubeHomePosterCollectionCell.self,
            forCellWithReuseIdentifier: YouTubeHomePosterCollectionCell.reuseIdentifier
        )
        collectionView.register(YouTubeFooterSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: YouTubeFooterSupplementaryView.reuseIdentifier)
        
        collectionView.isSkeletonable = true
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

// MARK: - Internal methods

extension YouTubeView {
    func insertRows(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }
}
