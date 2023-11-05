//
//  ScheduleView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit
import SkeletonView

final class ScheduleView: UIView {
    enum ElementKind {
        static let sectionHeader = "section-header-element-kind"
    }
    
    private var collectionView: UICollectionView!
    
    init(collectionViewDelegate: ScheduleContentController) {
        super.init(frame: .zero)
        
        configureView()
        configureCollectionView(delegate: collectionViewDelegate)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension ScheduleView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureCollectionView(delegate: ScheduleContentController) {
        let layout = ScheduleCollectionViewLayout().createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            AnimePosterCollectionViewCell.self,
            forCellWithReuseIdentifier: AnimePosterCollectionViewCell.reuseIdentifier)
        collectionView.register(
            ScheduleHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: ElementKind.sectionHeader,
            withReuseIdentifier: ScheduleHeaderSupplementaryView.reuseIdentifier)
        
        collectionView.isSkeletonable = true
        
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.prefetchDataSource = delegate
    }
    
    func configureLayout() {
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

extension ScheduleView {
    func showSkeletonCollectionView() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideSkeletonCollectionView() {
        collectionView.hideSkeleton(reloadDataAfter: false)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
