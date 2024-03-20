//
//  ScheduleCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit

final class ScheduleCollectionViewLayout {
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
        let sectionContentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16)
        
        let screenWidth = environment.container.contentSize.width - sectionContentInsets.leading - sectionContentInsets.trailing
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupWidthFraction = isPhone ? 0.5 : (isPortrait ? 0.25 : 0.2)
        let groupWidth = groupWidthFraction * screenWidth
        let imageViewRatio = PosterCollectionViewCell.imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let groupHeight = imageHeight + PosterCollectionViewCell.cellHeightWithoutImage + item.contentInsets.top + item.contentInsets.bottom
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: isPhone ? 2 : (isPortrait ? 4 : 5))
        group.interItemSpacing = .fixed(8)
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionContentInsets
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
