//
//  SettingsCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsCollectionViewLayout {
    typealias Section = SettingsContentController.Section
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Layout section is not found.")
            }
            switch section {
                case .videoPlayer:
                    return self.configureVideoPlayerSection(layoutEnvironment: layoutEnvironment)
                case .appearance:
                    return self.configureAppearanceSection()
            }
        }
        return layout
    }
    
    private func configureVideoPlayerSection(layoutEnvironment: NSCollectionLayoutEnvironment ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        
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
    
    private func configureAppearanceSection() -> NSCollectionLayoutSection {
        let itemLargeSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        let itemSmallSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: itemLargeSize)
        let smallItem = NSCollectionLayoutItem(layoutSize: itemSmallSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [largeItem, smallItem, smallItem])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
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
