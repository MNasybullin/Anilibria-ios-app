//
//  ProfileContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.02.2024.
//

import UIKit

protocol ProfileContentControllerDelegate: AnyObject {
    func showSite(url: URL)
    func showTeam(data: TeamAPIModel)
    func showAppItem(type: ProfileContentController.AppItem)
}

@MainActor
final class ProfileContentController: NSObject {
    typealias Localization = Strings.ProfileModule
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int, CaseIterable {
        case user, anilibria, app
    }
    
    enum Item: Hashable {
        case user
        case anilibria(AnilibriaItem)
        case app(AppItem)
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            switch (lhs, rhs) {
                case (.user, .user):
                    return true
                case (.anilibria(let leftAnilibriaItem), .anilibria(let rightAnilibriaItem)):
                    return leftAnilibriaItem == rightAnilibriaItem
                case (.app(let leftAppItem), .app(let rightAppItem)):
                    return leftAppItem == rightAppItem
                default:
                    return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
                case .user:
                    hasher.combine("user")
                case .anilibria(let anilibriaItem):
                    hasher.combine("anilibria")
                    hasher.combine(anilibriaItem)
                case .app(let appItem):
                    hasher.combine("app")
                    hasher.combine(appItem)
            }
        }
    }
    
    enum AnilibriaItem: CustomStringConvertible {
        case site, team, vk, telegram, youtube, discord
        
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
    
    enum AppItem: CaseIterable, CustomStringConvertible {
        case settings, aboutApp
        
        var description: String {
            switch self {
                case .settings: Localization.App.settings
                case .aboutApp: Localization.App.aboutApp
            }
        }
    }
    
    private let customView: ProfileView
    private let userController = UserController()
    private let model = ProfileModel()
    private lazy var dataSource = makeDataSource()
    weak var delegate: ProfileContentControllerDelegate?
    
    init(customView: ProfileView) {
        self.customView = customView
        super.init()
        
        setupCollectionView()
        applySnapshot(animatingDifferences: false)
    }
}

// MARK: - Private methods

private extension ProfileContentController {
    func setupCollectionView() {
        customView.collectionView.delegate = self
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: customView.collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                
                switch itemIdentifier {
                    case .user:
                        self?.configureUserCell(collectionView, indexPath: indexPath)
                    case .anilibria(let type):
                        self?.configureListCell(collectionView, indexPath: indexPath, text: type.description)
                    case .app(let type):
                        self?.configureListCell(collectionView, indexPath: indexPath, text: type.description)
                }
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([.user], toSection: .user)
        
        snapshot.appendItems([
            .anilibria(.site),
            .anilibria(.team),
            .anilibria(.vk),
            .anilibria(.telegram),
            .anilibria(.youtube),
            .anilibria(.discord)
        ], toSection: .anilibria)
        
        snapshot.appendItems([
            .app(.settings),
            .app(.aboutApp)
        ], toSection: .app)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func configureUserCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func configureListCell(_ collectionView: UICollectionView, indexPath: IndexPath, text: String) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewListCell.reuseIdentifier, for: indexPath) as? UICollectionViewListCell else {
            fatalError("Can`t create new list cell")
        }
        var content = cell.defaultContentConfiguration()
        content.text = text
        cell.contentConfiguration = content
        cell.accessories = [.disclosureIndicator()]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            print("item is not found", #function)
            return
        }
        switch item {
            case .user: break
            case .anilibria(let type):
                if type == .team {
                    didSelectTeamRow(indexPath: indexPath)
                } else {
                    guard let url = model.getUrl(forAnilibriaItem: type) else {
                        print("url is nil", #function)
                        return
                    }
                    delegate?.showSite(url: url)
                }
            case .app(let type):
                delegate?.showAppItem(type: type)
        }
    }
    
    private func didSelectTeamRow(indexPath: IndexPath) {
        guard let cell = customView.collectionView.cellForItem(at: indexPath) as? UICollectionViewListCell else {
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
        
        Task(priority: .userInitiated) {
            do {
                let team = try await model.getTeam()
                cell.accessories = [.disclosureIndicator()]
                delegate?.showTeam(data: team)
            } catch {
                print("Error = ", error, #function)
                cell.accessories = [.disclosureIndicator()]
            }
        }
    }
}
