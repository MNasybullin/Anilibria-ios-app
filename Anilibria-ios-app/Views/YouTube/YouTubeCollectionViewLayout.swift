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
        let section = configureSection()
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.interItemSpacing = .fixed(16)
      
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 16,
            trailing: 16)
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
