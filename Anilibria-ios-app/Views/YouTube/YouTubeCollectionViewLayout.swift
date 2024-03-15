//
//  YouTubeCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.12.2023.
//

import UIKit

final class YouTubeCollectionViewLayout {
    typealias ElementKind = YouTubeView.ElementKind
    
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
        
        let groupWidthFraction = isPhone ? 1 : (isPortrait ? 0.5 : 0.33)
        let groupWidth = groupWidthFraction * screenWidth
        let imageViewRatio = YouTubeHomePosterCollectionCell.imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let groupHeight = imageHeight + YouTubeHomePosterCollectionCell.cellHeightWithoutImage + item.contentInsets.top + item.contentInsets.bottom
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: isPhone ? 1 : (isPortrait ? 2 : 3))
        group.interItemSpacing = .fixed(16)
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = sectionContentInsets
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: ElementKind.sectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [sectionFooter]
        
        return section
    }
}
