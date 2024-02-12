//
//  ProfileContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.02.2024.
//

import UIKit

final class ProfileContentController: NSObject {
    typealias Localization = Strings.ProfileModule
    
    enum Section: Int, CaseIterable {
        case user
        case anilibria
        case app
    }
    
    enum Anilibria: Int, CaseIterable, CustomStringConvertible {
        case site
        case team
        case vk
        case telegram
        case youtube
        case discord
        
        var description: String {
            switch self {
                case .site: Localization.Anilibria.site
                case .team: Localization.Anilibria.team
                case .vk: Localization.Anilibria.vk
                case .telegram: Localization.Anilibria.telegram
                case .youtube: Localization.Anilibria.youtube
                case .discord: Localization.Anilibria.discord
            }
        }
    }
    
    enum App: Int, CaseIterable, CustomStringConvertible {
        case settings
        case aboutApp
        
        var description: String {
            switch self {
                case .settings: Localization.App.settings
                case .aboutApp: Localization.App.aboutApp
            }
        }
    }
    
    private let customView: ProfileView
    private let userController = UserController()
    
    init(customView: ProfileView) {
        self.customView = customView
        super.init()
        
        setupCollectionView()
    }
}

// MARK: - Private methods

private extension ProfileContentController {
    func setupCollectionView() {
        customView.collectionView.delegate = self
        customView.collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewListCell else {
            print("selected cell For Item not found", #function)
            return
        }
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: activityIndicator,
            placement: .trailing(),
            tintColor: .systemGray)
        let indicatorAccessory = UICellAccessory.customView(configuration: configuration)
        cell.accessories = [indicatorAccessory]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProfileContentController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionEnum = Section(rawValue: section) else {
            fatalError("Section is not found")
        }
        switch sectionEnum {
            case .user:
                return 1
            case .anilibria:
                return Anilibria.allCases.count
            case .app:
                return App.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionEnum = Section(rawValue: indexPath.section) else {
            fatalError("Section is not found")
        }
        switch sectionEnum {
            case .user:
                return configureUserCell(collectionView, indexPath: indexPath)
            case .anilibria:
                return configureAnilibriaCell(collectionView, indexPath: indexPath)
            case .app:
                return configureAppCell(collectionView, indexPath: indexPath)
        }
    }
    
    private func configureUserCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.reuseIdentifier, for: indexPath)
        
        cell.contentView.addSubview(userController.customView)
        
        userController.customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userController.customView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            userController.customView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            userController.customView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            userController.customView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        return cell
    }
    
    private func configureAnilibriaCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewListCell.reuseIdentifier, for: indexPath) as? UICollectionViewListCell else {
            fatalError("Can`t create new list cell")
        }
        guard let rowType = Anilibria(rawValue: indexPath.row) else {
            print("AniLirbia enum case not found", #function)
            return cell
        }
        var content = cell.defaultContentConfiguration()
        content.text = rowType.description
        cell.contentConfiguration = content
        cell.accessories = [.disclosureIndicator()]
        return cell
    }
    
    private func configureAppCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewListCell.reuseIdentifier, for: indexPath) as? UICollectionViewListCell else {
            fatalError("Can`t create new list cell")
        }
        guard let rowType = App(rawValue: indexPath.row) else {
            print("App enum case not found", #function)
            return cell
        }
        var content = cell.defaultContentConfiguration()
        content.text = rowType.description
        cell.contentConfiguration = content
        cell.accessories = [.disclosureIndicator()]
        return cell
    }
}
