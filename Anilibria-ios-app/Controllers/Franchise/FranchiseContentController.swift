//
//  FranchiseContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit

protocol FranchiseContentControllerDelegate: AnyObject {
    func didSelectItem(data: TitleAPIModel, image: UIImage?)
}

@MainActor
final class FranchiseContentController: NSObject {
    typealias DataSource = FranchiseDiffableDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, FranchisePosterItem>
    
    // MARK: Transition properties
    private (set) var selectedCell: PosterCollectionViewCell?
    private (set) var selectedCellImageViewSnapshot: UIView?
    
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
    
    let customView: FranchiseView
    weak var delegate: FranchiseContentControllerDelegate?
    
    private var sectionIdentifier: [String] = []
    private var status: Status = .normal
    private lazy var dataSource = makeDataSource()
    private let model: FranchiseModel
    private var data: [[FranchisePosterItem]] = [[]]
    
    init(franchisesData: [FranchisesAPIModel], customView: FranchiseView) {
        self.customView = customView
        self.model = FranchiseModel(franchisesData: franchisesData)
        super.init()
        
        customView.collectionView.delegate = self
        customView.collectionView.prefetchDataSource = self
        
        setupSupplementaryViewProvider()
        applyInitialSnapshot()
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
        dataSource.numberOfSections = model.getNumberOfSections()
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        data.forEach { items in
            let section: String = UUID().uuidString
            self.sectionIdentifier.append(section)
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences) { [weak self] in
            self?.customView.manualUpdateConstraints()
        }
    }
    
    func applyInitialSnapshot() {
        let snapshot = Snapshot()
        dataSource.apply(snapshot)
        customView.showCollectionViewSkeleton()
    }
    
    func loadData() {
        guard status != .loading else { return }
        status = .loading
        if data.isEmpty {
            customView.showCollectionViewSkeleton()
        }
        Task(priority: .userInitiated) {
            do {
                data = try await model.getFranchisesTitles()
                
                customView.hideCollectionViewSkeleton()
                applySnapshot()
                status = .normal
            } catch {
                status = .normal
                print(error)
            }
        }
    }
    
    func setupSupplementaryViewProvider() {
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FranchiseHeaderSupplementaryView.reuseIdentifier, for: indexPath) as? FranchiseHeaderSupplementaryView else {
                fatalError("Header is not FranchiseHeaderSupplementaryView")
            }
            let title = self?.data[indexPath.section].first?.sectionName ?? ""
            headerView.configureView(title: title)
            return headerView
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FranchiseContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        let posterItem = data[section][row]
        
        guard let item = model.getTitleAPIModel(forID: posterItem.id) else {
            print("Selected item is not found")
            return
        }
        selectedCell = collectionView.cellForItem(at: indexPath) as? PosterCollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        delegate?.didSelectItem(data: item, image: posterItem.image)
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
