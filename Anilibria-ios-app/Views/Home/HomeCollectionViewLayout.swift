//
//  HomeCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import UIKit

final class HomeCollectionViewLayout {
    typealias Section = HomeContentController.Section
    typealias DataSource = HomeContentController.DataSource
    
    enum Constants {
        static let headerPinToVisibleBounds = false
    }
    
    weak var dataSource: DataSource?
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let item = self.dataSource?.itemIdentifier(for: IndexPath(row: 0, section: sectionIndex))
            guard let section: Section = item?.section ?? Section(rawValue: sectionIndex) else {
                fatalError("Layout section is not found.")
            }
            
            switch section {
                case .today:
                    return self.configureTodaySection()
                case .watching:
                    return self.configureWatchingSection()
                case .updates:
                    return self.configureUpdateSection()
                case .youtube:
                    return self.configureYouTubeSection()
            }
        }
        return layout
    }
    
    // MARK: Today Section
    func configureTodaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(350))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7),
            heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        sectionHeader.zIndex = 2
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: Watching Section
    func configureWatchingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.70),
            heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        sectionHeader.zIndex = 2
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: Update Section
    func configureUpdateSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        sectionHeader.zIndex = 2
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: YouTube Section
    func configureYouTubeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.90),
            heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        sectionHeader.zIndex = 2
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
