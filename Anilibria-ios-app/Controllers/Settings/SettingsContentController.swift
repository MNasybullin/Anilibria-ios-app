//
//  SettingsContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsContentController: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias AppearanceStyle = UIUserInterfaceStyle
    
    enum Section: Int, CaseIterable {
        case appearance
        
        var headerText: String? {
            switch self {
                case .appearance:
                    Strings.SettingsModule.HeaderText.appearance
            }
        }
    }
    
    enum Item: Hashable {
        case appearance(AppearanceStyle)
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            switch (lhs, rhs) {
                case (.appearance(let lType), .appearance(let rType)):
                    return lType == rType
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
                case .appearance(let type):
                    hasher.combine("appearance")
                    hasher.combine(type)
            }
        }
    }
    
    private let customView: SettingsView
    private lazy var dataSource = makeDataSource()
    private let model = SettingsModel()
    
    private var selectedAppearanceCell: SettingsAppearanceCell?
    
    init(customView: SettingsView) {
        self.customView = customView
        super.init()
        
        setupCollectionView()
        applySnapshot()
    }
}

// MARK: - Private methods

private extension SettingsContentController {
    func setupCollectionView() {
        customView.collectionView.delegate = self
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([
            .appearance(.unspecified),
            .appearance(.dark),
            .appearance(.light)
        ], toSection: .appearance)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: customView.collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                
                switch itemIdentifier {
                    case .appearance(let style):
                        self?.configureAppearanceCell(collectionView, indexPath: indexPath, style: style)
                }
            })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingsCollectionViewHeader.reuseIdentifier, for: indexPath) as? SettingsCollectionViewHeader else {
                fatalError("Can`t create header view")
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            headerView.setTitle(text: section.headerText)
            return headerView
        }
        
        return dataSource
    }
    
    func configureAppearanceCell(_ collectionView: UICollectionView, indexPath: IndexPath, style: AppearanceStyle) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsAppearanceCell.reuseIdentifier, for: indexPath) as? SettingsAppearanceCell else {
            fatalError("Can`t create SettingsAppearanceCell")
        }
        
        if style == model.appearance {
            cell.isSelected = true
            selectedAppearanceCell = cell
        }
        
        cell.configureView(style: style)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SettingsContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath),
        let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        switch item {
            case .appearance(let style):
                guard let cell = cell as? SettingsAppearanceCell else {
                     return
                }
                selectedAppearanceCell?.isSelected = false
                selectedAppearanceCell?.configureViewForIsSelected()
                cell.configureView(style: style)
                model.appearance = style
                selectedAppearanceCell = cell
        }
    }
}
