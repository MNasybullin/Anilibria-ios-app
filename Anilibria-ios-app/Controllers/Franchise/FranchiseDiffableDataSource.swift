//
//  FranchiseDiffableDataSource.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit
import SkeletonView

final class FranchiseDiffableDataSource: UICollectionViewDiffableDataSource<String, HomePosterItem> {
}

// MARK: - SkeletonCollectionViewDataSource

extension FranchiseDiffableDataSource: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return PosterCollectionViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
