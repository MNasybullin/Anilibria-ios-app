//
//  ProfileCollectionViewLayout.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.02.2024.
//

import UIKit

final class ProfileCollectionViewLayout {
    typealias Section = ProfileContentController.Section
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Layout section is not found.")
            }
            switch section {
                case .user:
                    return self.configureUserSection()
                case .anilibria, .app:
                    return NSCollectionLayoutSection.list(using: .init(appearance: .insetGrouped), layoutEnvironment: layoutEnvironment)
            }
        }
        return layout
    }
    
    // MARK: User Section
    func configureUserSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.33))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
