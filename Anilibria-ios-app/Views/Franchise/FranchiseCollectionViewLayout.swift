//
//  FranchiseCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit

final class FranchiseCollectionViewLayout {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, environment in
            guard let self else { fatalError("Layout instance is nil.") }
            return self.configureSection(environment: environment)
        }
        return layout
    }
    
    private func configureSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let isPhone = environment.traitCollection.userInterfaceIdiom == .phone
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        let screenWidth = environment.container.contentSize.width
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupWidth = (isPhone ? 0.45 : (isPortrait ? 0.25: 0.2)) * screenWidth
        let imageViewRatio = PosterCollectionViewCell.imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let groupHeight = imageHeight + PosterCollectionViewCell.cellHeightWithoutImage + item.contentInsets.top + item.contentInsets.bottom
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 8,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
