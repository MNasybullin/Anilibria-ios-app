//
//  FranchiseContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit

@MainActor
final class FranchiseContentController: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<String, HomePosterItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, HomePosterItem>
        
    enum Status {
        case normal
        case loading
                
        static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
                case (.normal, .normal), (.loading, .loading):
                    return true
                default:
                    return false
            }
        }
        
        static func != (lhs: Status, rhs: Status) -> Bool {
            return !(lhs == rhs)
        }
    }
    
    weak var customView: FranchiseView!
    
    private var section: [String] = []
    private var status: Status = .normal
    private lazy var dataSource = makeDataSource()
    private let model: FranchiseModel
    private var data: [[HomePosterItem]] = [[]]
    
    init(franchisesData: [FranchisesAPIModel], customView: FranchiseView!) {
        self.customView = customView
        self.model = FranchiseModel(franchisesData: franchisesData)
        super.init()
        
        customView.collectionView.delegate = self
        customView.collectionView.prefetchDataSource = self
        
        initialSnapshot()
        loadData()
    }
}

// MARK: - Private methods

private extension FranchiseContentController {
    func makeDataSource() -> DataSource {
        let dataSource = FranchiseDiffableDataSource(
            collectionView: customView.collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, _) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PosterCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? PosterCollectionViewCell
                let section = indexPath.section
                let row = indexPath.row
                guard let item = self?.data[section][row] else { return cell }
                if item.image == nil {
                    self?.model.requestImage(from: item.imageUrlString) { image in
                        self?.data[section][row].image = image
                        cell?.setImage(image, urlString: item.imageUrlString)
                    }
                }
                cell?.configureCell(item: item)
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        print("count = ", data.count)
        data.forEach { items in
            let section: String = UUID().uuidString
            self.section.append(section)
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences) { [weak self] in
            self?.customView.manualUpdateConstraints()
        }
    }
    
    func initialSnapshot() {
        data.append([HomePosterItem(name: "Skeleton", imageUrlString: "")])
        var snapshot = Snapshot()
        snapshot.appendSections([UUID().uuidString])
        snapshot.appendItems(data[0])

        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.customView.manualUpdateConstraints()
        }
        customView.showCollectionViewSkeleton()
    }
    
    func loadData() {
        guard status != .loading else { return }
        if data.isEmpty {
            customView.showCollectionViewSkeleton()
        }
        Task(priority: .userInitiated) {
            do {
                status = .loading
                data = try await self.model.getFranchisesTitles()
                
                customView.hideCollectionViewSkeleton()
                applySnapshot()
                status = .normal
            } catch {
                status = .normal
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FranchiseContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select ", indexPath)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension FranchiseContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            let section = indexPath.section
            let row = indexPath.row
            if item.image == nil {
                model.requestImage(from: item.imageUrlString) { [weak self] image in
                    self?.data[section][row].image = image
                }
            }
        }
    }
}
