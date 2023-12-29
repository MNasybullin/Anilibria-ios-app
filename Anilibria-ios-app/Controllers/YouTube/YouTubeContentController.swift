//
//  YouTubeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.12.2023.
//

import UIKit

protocol YouTubeContentControllerDelegate: AnyObject {
    func insertItems(at indexPaths: [IndexPath])
    func didSelectItem(rawdata: YouTubeAPIModel)
}

final class YouTubeContentController: NSObject {
    typealias Status = YouTubeView.Status
    
    weak var delegate: YouTubeContentControllerDelegate?
    weak var collectionView: UICollectionView?
    
    private let model: YouTubeModel
    private var data: [HomePosterItem]
    private var status = Status.normal {
        didSet { updateFooterView() }
    }
    
    init(data: [HomePosterItem], rawData: [YouTubeAPIModel]) {
        self.data = data
        self.model = YouTubeModel(rawData: rawData)
        super.init()
        
        model.imageModelDelegate = self
        model.delegate = self
    }
}

// MARK: Private methods

private extension YouTubeContentController {
    func loadMoreData() {
        guard model.needLoadMoreData == true,
              status == .normal else { return }
        status = .loadingMore
        model.requestData(after: data.count)
    }
    
    func updateFooterView() {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let footerView = collectionView?.supplementaryView(forElementKind: YouTubeView.ElementKind.sectionFooter, at: indexPath) as? YouTubeFooterSupplementaryView else { return }
        footerView.configureView(status: status)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDelegate

extension YouTubeContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let rawData = model.getRawData(row: indexPath.row)
        delegate?.didSelectItem(rawdata: rawData)
    }
}

// MARK: - UICollectionViewDataSource

extension YouTubeContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: YouTubeFooterSupplementaryView.reuseIdentifier, for: indexPath) as? YouTubeFooterSupplementaryView else {
            fatalError("Header is not YouTubeFooterSupplementaryView")
        }
        footer.configureView(status: status)
        footer.delegate = self
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YouTubeHomePosterCollectionCell.reuseIdentifier, for: indexPath) as? YouTubeHomePosterCollectionCell else {
            fatalError("Can`t create new cell")
        }
        let row = indexPath.row
        let item = data[row]
        if indexPath.row == data.count - 4 {
            loadMoreData()
        }
        if item.image == nil {
            model.requestImage(from: item.imageUrlString) { [weak self] image in
                self?.data[row].image = image
                cell.setImage(image, urlString: item.imageUrlString)
            }
        }
        cell.configureCell(item: item)
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension YouTubeContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let row = indexPath.row
            let item = data[row]
            guard item.image == nil else {
                return
            }
            model.requestImage(from: item.imageUrlString) { [weak self] image in
                self?.data[row].image = image
            }
        }
    }
}

// MARK: - YouTubeModelDelegate

extension YouTubeContentController: YouTubeModelDelegate {
    func updateData(_ data: [HomePosterItem]) {
        DispatchQueue.main.async {
            let count = self.data.count
            let indexPaths = (0..<data.count).map {
                IndexPath(row: $0 + count, section: 0)
            }
            self.data.append(contentsOf: data)
            self.delegate?.insertItems(at: indexPaths)
            self.status = .normal
        }
    }
    
    func failedRequestData(error: Error) {
        DispatchQueue.main.async {
            self.status = .loadingMoreFail
        }
    }
}

// MARK: - ImageModelDelegate

extension YouTubeContentController: ImageModelDelegate {
    func failedRequestImage(error: Error) {
        print(#function, error)
    }
}

// MARK: - YouTubeFooterSupplementaryViewDelegate

extension YouTubeContentController: YouTubeFooterSupplementaryViewDelegate {
    func didTappedRefreshButton() {
        status = .normal
        loadMoreData()
    }
}