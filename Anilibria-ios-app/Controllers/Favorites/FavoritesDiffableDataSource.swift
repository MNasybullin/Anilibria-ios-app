//
//  FavoritesDiffableDataSource.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.01.2024.
//

import UIKit
import SkeletonView

final class FavoritesDiffableDataSource: UICollectionViewDiffableDataSource<FavoritesContentController.Section, HomePosterItem> {
}

// MARK: - SkeletonCollectionViewDataSource

extension FavoritesDiffableDataSource: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return PosterCollectionViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
}
