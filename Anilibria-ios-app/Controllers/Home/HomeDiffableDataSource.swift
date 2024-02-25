//
//  HomeDiffableDataSource.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.02.2024.
//

import UIKit
import SkeletonView

final class HomeDiffableDataSource: UICollectionViewDiffableDataSource<HomeContentController.Section, HomeContentController.Item> {
}

// MARK: - SkeletonCollectionViewDataSource

extension HomeDiffableDataSource: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        HomeHeaderSupplementaryView.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        guard let section = HomeContentController.Section.init(rawValue: indexPath.section) else {
            fatalError("Unknown Home Module section")
        }
        switch section {
            case .today:
                return TodayHomePosterCollectionCell.reuseIdentifier
            case .updates:
                return UpdatesHomePosterCollectionCell.reuseIdentifier
            case .youtube:
                return YouTubeHomePosterCollectionCell.reuseIdentifier
        }
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        HomeContentController.Section.allCases.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}
