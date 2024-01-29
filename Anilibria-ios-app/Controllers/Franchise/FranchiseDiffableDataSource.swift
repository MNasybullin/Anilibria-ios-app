//
//  FranchiseDiffableDataSource.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit
import SkeletonView

final class FranchiseDiffableDataSource: UICollectionViewDiffableDataSource<String, FranchisePosterItem> {
    /// For SkeletonView
    ///  
    ///  default = 1
    var numberOfSections: Int = 1
}

// MARK: - SkeletonCollectionViewDataSource

extension FranchiseDiffableDataSource: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return FranchiseHeaderSupplementaryView.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return PosterCollectionViewCell.reuseIdentifier
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        numberOfSections
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
