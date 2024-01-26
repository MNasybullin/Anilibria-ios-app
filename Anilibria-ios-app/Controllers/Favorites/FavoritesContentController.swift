//
//  FavoritesContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.01.2024.
//

import UIKit

protocol FavoritesContentControllerDelegate: AnyObject {
    func didSelectItem(data: TitleAPIModel, image: UIImage?)
}

@MainActor
final class FavoritesContentController: NSObject {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomePosterItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomePosterItem>
    
    enum Section: Int {
        case main
    }
    
    enum Status {
        case normal
        case loading
        case favoritesIsEmpty
        case userIsNotAuthorized
        case error(Error)
                
        static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
                case (.normal, .normal), (.loading, .loading), (.error, .error):
                    return true
                default:
                    return false
            }
        }
        
        static func != (lhs: Status, rhs: Status) -> Bool {
            return !(lhs == rhs)
        }
    }
    
    weak var delegate: FavoritesContentControllerDelegate?
    weak var customView: FavoritesView!
    
    private lazy var dataSource = makeDataSource()
    private let model = FavoritesModel.shared
    
    private var data: [HomePosterItem] = []
    
    private var status: Status = .normal {
        didSet {
            if status != .normal && status != .loading {
                customView.showCollectionViewSkeleton()
            }
            customView.updateView(withStatus: status)
        }
    }
    
    init(customView: FavoritesView, delegate: FavoritesContentControllerDelegate?) {
        self.customView = customView
        self.delegate = delegate
        super.init()
        
        customView.collectionView.delegate = self
        customView.collectionView.prefetchDataSource = self
        
        applySnapshot()
        loadData()
    }
}

// MARK: - Private methods

private extension FavoritesContentController {
    func makeDataSource() -> DataSource {
        let dataSource = FavoritesDiffableDataSource(
            collectionView: customView.collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, _) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PosterCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? PosterCollectionViewCell
                guard let item = self?.data[indexPath.row] else { return cell }
                if item.image == nil {
                    self?.model.requestImage(from: item.imageUrlString) { image in
                        self?.data[indexPath.row].image = image
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
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        
        // for skeletonView. (Иначе пропадает skeleton на image)
        let noImageData = data.filter { $0.image == nil }
        snapshot.reconfigureItems(noImageData)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Internal methods

extension FavoritesContentController {
    func loadData() {
        guard status != .loading else { return }
        if data.isEmpty {
            customView.showCollectionViewSkeleton()
        }
        Task(priority: .userInitiated) {
            do {
                status = .loading
                let models = try await self.model.getFavorites(withForceUpdate: true)
                
                var newData = [HomePosterItem]()
                models.forEach { model in
                    var item = HomePosterItem(fromTitleAPIModel: model)
                    let oldItem = data.first { $0.name == item.name }
                    item.image = oldItem?.image
                    newData.append(item)
                }
                data = newData.reversed()
                
                customView.hideCollectionViewSkeleton()
                applySnapshot()
                status = data.isEmpty ? .favoritesIsEmpty : .normal
            } catch let error as MyInternalError {
                status = error == .userIsNotFoundInUserDefaults ? .userIsNotAuthorized : .error(error)
            } catch {
                status = .error(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        guard let data = model.getTitleModel(fromName: item.name) else {
            print("not found data in model")
            return
        }
        delegate?.didSelectItem(data: data, image: item.image)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension FavoritesContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            if item.image == nil {
                model.requestImage(from: item.imageUrlString) { [weak self] image in
                    self?.data[indexPath.row].image = image
                }
            }
        }
    }
}
