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
        static var headerHeight: CGFloat {
            let titleHeight = HomeHeaderSupplementaryView.Constants.titleFont.lineHeight
            let headerHeight = titleHeight + HomeHeaderSupplementaryView.Constants.layoutConstants.top - HomeHeaderSupplementaryView.Constants.layoutConstants.bottom
            return headerHeight
        }
    }
    
    weak var dataSource: DataSource?
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let item = self.dataSource?.itemIdentifier(for: IndexPath(row: 0, section: sectionIndex))
            guard let section: Section = item?.section ?? Section(rawValue: sectionIndex) else {
                fatalError("Layout section is not found.")
            }
            
            switch section {
                case .today:
                    return self.configureTodaySection(environment: environment)
                case .watching:
                    return self.configureWatchingSection(environment: environment)
                case .updates:
                    return self.configureUpdateSection(environment: environment)
                case .youtube:
                    return self.configureYouTubeSection(environment: environment)
            }
        }
        return layout
    }
    
    // MARK: Today Section
    func configureTodaySection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupWidth = 0.7 * environment.container.contentSize.width
        let imageViewRatio = TodayHomePosterCollectionCell().imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let labelHeight = TodayHomePosterCollectionCell.Constants.titleFont.lineHeight * CGFloat(TodayHomePosterCollectionCell.Constants.titleLabelNumberOfLines)
        let gap = 1.0
        let spacing = UpdatesHomePosterCollectionCell.Constants.stackSpacing
        let groupHeight = imageHeight + spacing + labelHeight + gap + item.contentInsets.top + item.contentInsets.bottom
        
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
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let screenWidth = environment.container.contentSize.width
            let minScale: CGFloat = 0.95
            let maxScale: CGFloat = 1.0
            items.forEach { item in
                guard item.representedElementCategory == .cell else { return }
                let distanceFromCenter = abs((item.frame.midX - offset.x) - screenWidth / 2.0)
                let scale = max(maxScale - (distanceFromCenter / screenWidth), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    // MARK: Watching Section
    func configureWatchingSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupWidth = 0.7 * environment.container.contentSize.width
        let imageViewRatio = WatchingHomeCollectionViewCell().imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let titleHeight = WatchingHomeCollectionViewCell.Constants.titleFont.lineHeight
        let subtitleHeight = WatchingHomeCollectionViewCell.Constants.subtitleFont.lineHeight
        let gap = 1.0
        let spacing = WatchingHomeCollectionViewCell.Constants.stackSpacing
        let groupHeight = imageHeight + spacing + titleHeight + spacing + subtitleHeight + gap + item.contentInsets.top + item.contentInsets.bottom
        
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
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: Update Section
    func configureUpdateSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupWidth = 0.45 * environment.container.contentSize.width
        let imageViewRatio = UpdatesHomePosterCollectionCell().imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let labelHeight = UpdatesHomePosterCollectionCell.Constants.titleFont.lineHeight * CGFloat(UpdatesHomePosterCollectionCell.Constants.titleLabelNumberOfLines)
        let gap = 1.0
        let spacing = UpdatesHomePosterCollectionCell.Constants.stackSpacing
        let groupHeight = imageHeight + spacing + labelHeight + gap + item.contentInsets.top + item.contentInsets.bottom
        
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
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: YouTube Section
    func configureYouTubeSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let groupWidth = 0.9 * environment.container.contentSize.width
        let imageViewRatio = YouTubeHomePosterCollectionCell().imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let labelHeight = YouTubeHomePosterCollectionCell.Constants.titleFont.lineHeight * CGFloat(YouTubeHomePosterCollectionCell.Constants.titleLabelNumberOfLines)
        let gap = 1.0
        let spacing = YouTubeHomePosterCollectionCell.Constants.stackSpacing
        let groupHeight = imageHeight + spacing + labelHeight + gap + item.contentInsets.top + item.contentInsets.bottom
        
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
            bottom: 16,
            trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = Constants.headerPinToVisibleBounds
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
