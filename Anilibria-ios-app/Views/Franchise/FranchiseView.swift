//
//  FranchiseView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit

final class FranchiseView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.FranchiseModule.HeaderTitle.franchiseViewingOrder
        label.textColor = .label
        let size = UIFont.preferredFont(forTextStyle: .headline).pointSize
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        return label
    }()
    
    private let layout = FranchiseCollectionViewLayout()
    private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout.createLayout())
    
    private var heightConstraint: NSLayoutConstraint!
    
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

private extension FranchiseView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupCollectionView() {
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier)
        collectionView.register(
            FranchiseHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FranchiseHeaderSupplementaryView.reuseIdentifier)
        
        collectionView.isSkeletonable = true
    }
    
    func setupLayout() {
        addSubview(titleLabel)
        addSubview(collectionView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = self.collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heightConstraint
        ])
    }
    
    func updateHeightConstraint() {
        let size = collectionView.collectionViewLayout.collectionViewContentSize
        self.heightConstraint.constant = size.height
    }
}

// MARK: - Internal methods

extension FranchiseView {
    func showCollectionViewSkeleton() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideCollectionViewSkeleton() {
        if collectionView.sk.isSkeletonActive {
            collectionView.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
    }
    
    func manualUpdateConstraints() {
        collectionView.performBatchUpdates({
            collectionView.collectionViewLayout.invalidateLayout()
        }, completion: { [weak self] isFinished in
            if isFinished {
                self?.updateHeightConstraint()
            }
        })
    }
}
