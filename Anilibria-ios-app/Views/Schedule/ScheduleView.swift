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
    
    private lazy var layout = ScheduleCollectionViewLayout().createLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    init() {
        super.init(frame: .zero)
        
        configureView()
        configureCollectionView()
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
    
    func configureCollectionView() {
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier)
        collectionView.register(
            ScheduleHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: ElementKind.sectionHeader,
            withReuseIdentifier: ScheduleHeaderSupplementaryView.reuseIdentifier)
        
        collectionView.isSkeletonable = true
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
