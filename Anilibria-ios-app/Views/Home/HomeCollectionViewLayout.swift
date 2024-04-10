//
//  HomeCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.10.2023.
//

import UIKit

protocol HomeCollectionViewLayoutCellConfigurable {
    static var imageViewRatio: CGFloat { get }
    static var cellHeightWithoutImage: CGFloat { get }
}

struct SectionConfiguration {
    let groupWidthFraction: CGFloat
    let itemLayoutSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0))
    let itemContentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: 8,
        bottom: 0,
        trailing: 8)
    let sectionContentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: 0,
        bottom: 8,
        trailing: 0)
    let orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    let headerPinToVisibleBounds: Bool = false
    var headerHeight: CGFloat {
        let titleHeight = HomeHeaderSupplementaryView.Constants.titleFont.lineHeight
        let headerHeight = titleHeight + HomeHeaderSupplementaryView.Constants.layoutConstants.top - HomeHeaderSupplementaryView.Constants.layoutConstants.bottom
        return headerHeight
    }
    let cellConfigurable: HomeCollectionViewLayoutCellConfigurable.Type
}

final class HomeCollectionViewLayout {
    typealias Section = HomeContentController.Section
    typealias DataSource = HomeContentController.DataSource
    
    private var sectionConfigurations: [Section: SectionConfiguration] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return configurePadSectionConfigurations()
        } else {
            return configurePhoneSectionConfigurations()
        }
    }
    
    private var offsetX: CGFloat?
    
    weak var dataSource: DataSource?
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self else { fatalError("Layout instance is nil.") }
            let item = self.dataSource?.itemIdentifier(for: IndexPath(row: 0, section: sectionIndex))
            guard let section: Section = item?.section ?? Section(rawValue: sectionIndex),
                  let configuration = self.sectionConfigurations[section] else {
                fatalError("Layout section or configuration is not found.")
            }
            
            switch section {
                case .today:
                    var layoutSection = self.configureSection(configuration: configuration, environment: environment)
                    todaySectionScrollLayout(section: &layoutSection)
                    return layoutSection
                case .watching, .updates, .youtube:
                    return self.configureSection(
                        configuration: configuration,
                        environment: environment)
            }
        }
        return layout
    }
}

// MARK: - Private methods

private extension HomeCollectionViewLayout {
    
    func configurePhoneSectionConfigurations() -> [Section: SectionConfiguration] {
        return [
            .today: .init(
                groupWidthFraction: 0.7,
                orthogonalScrollingBehavior: .groupPagingCentered,
                cellConfigurable: TodayHomePosterCollectionCell.self),
            .watching: .init(
                groupWidthFraction: 0.7,
                orthogonalScrollingBehavior: .continuous,
                cellConfigurable: WatchingHomeCollectionViewCell.self),
            .updates: .init(
                groupWidthFraction: 0.45,
                orthogonalScrollingBehavior: .continuous,
                cellConfigurable: UpdatesHomePosterCollectionCell.self),
            .youtube: .init(
                groupWidthFraction: 0.9,
                orthogonalScrollingBehavior: .continuous,
                cellConfigurable: YouTubeHomePosterCollectionCell.self)
        ]
    }

    func configurePadSectionConfigurations() -> [Section: SectionConfiguration] {
        return [
            .today: .init(
                groupWidthFraction: 0.3,
                orthogonalScrollingBehavior: .continuousGroupLeadingBoundary,
                cellConfigurable: TodayHomePosterCollectionCell.self),
            .watching: .init(
                groupWidthFraction: 0.45,
                orthogonalScrollingBehavior: .continuous,
                cellConfigurable: WatchingHomeCollectionViewCell.self),
            .updates: .init(
                groupWidthFraction: 0.25,
                orthogonalScrollingBehavior: .continuous,
                cellConfigurable: UpdatesHomePosterCollectionCell.self),
            .youtube: .init(
                groupWidthFraction: 0.55,
                orthogonalScrollingBehavior: .continuous,
                cellConfigurable: YouTubeHomePosterCollectionCell.self)
        ]
    }
    
    func configureSection(configuration: SectionConfiguration, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let screenWidth = min(environment.container.contentSize.width, environment.container.contentSize.height)
        
        let item = NSCollectionLayoutItem(layoutSize: configuration.itemLayoutSize)
        item.contentInsets = configuration.itemContentInsets
        
        let groupWidth = configuration.groupWidthFraction * screenWidth
        let imageViewRatio = configuration.cellConfigurable.imageViewRatio
        let imageHeight = (groupWidth - item.contentInsets.leading - item.contentInsets.trailing) / imageViewRatio
        let groupHeight = imageHeight + configuration.cellConfigurable.cellHeightWithoutImage + item.contentInsets.top + item.contentInsets.bottom
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(groupHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = configuration.sectionContentInsets
        section.orthogonalScrollingBehavior = configuration.orthogonalScrollingBehavior
        
        let sectionHeader = getSectionHeader(configuration: configuration)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func todaySectionScrollLayout(section: inout NSCollectionLayoutSection) {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return
        }
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            let screenWidth = environment.container.contentSize.width
            let minScale: CGFloat = 0.95
            let maxScale: CGFloat = 1.0
            
            items.forEach { item in
                guard item.representedElementCategory == .cell else { return }
                let distanceFromCenter = abs((item.frame.midX - offset.x) - screenWidth / 2.0)
                let scale = max(maxScale - (distanceFromCenter / screenWidth), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                
                if let offsetX = self.offsetX,
                    offsetX != offset.x,
                    (0.99999...1.0).contains(scale) {
                    let feedbackGenerator = UISelectionFeedbackGenerator()
                    feedbackGenerator.selectionChanged()
                }
            }
            self.offsetX = offset.x
        }
    }
    
    // MARK: Section Header
    func getSectionHeader(configuration: SectionConfiguration) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(configuration.headerHeight))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        sectionHeader.pinToVisibleBounds = configuration.headerPinToVisibleBounds
        return sectionHeader
    }
}
