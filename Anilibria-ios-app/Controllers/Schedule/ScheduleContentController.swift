//
//  ScheduleContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit
import SkeletonView

protocol ScheduleContentControllerDelegate: AnyObject {
    func hideSkeletonCollectionView()
    func reloadData()
    func didSelectItem(_ rawData: TitleAPIModel, image: UIImage?)
}

final class ScheduleContentController: NSObject {
    weak var delegate: ScheduleContentControllerDelegate?
    
    // MARK: Transition properties
    private (set) var selectedCell: PosterCollectionViewCell?
    private (set) var selectedCellImageViewSnapshot: UIView?
    
    private lazy var model: ScheduleModel = {
        let model = ScheduleModel()
        model.imageModelDelegate = self
        model.scheduleModelOutput = self
        return model
    }()
    
    private var data: [ScheduleItem] = []
    
    init(delegate: ScheduleContentControllerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }
    
    func requestData() {
        model.requestData()
    }
}

// MARK: - UICollectionViewDelegate

extension ScheduleContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rawData = model.getRawData(indexPath: indexPath) else {
            return
        }
        let image = data[indexPath.section].animePosterItems[indexPath.row].image
        selectedCell = collectionView.cellForItem(at: indexPath) as? PosterCollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        delegate?.didSelectItem(rawData, image: image)
    }
}

// MARK: - UICollectionViewDataSource

extension ScheduleContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScheduleHeaderSupplementaryView.reuseIdentifier, for: indexPath) as? ScheduleHeaderSupplementaryView else {
            fatalError("Header is not ScheduleHeaderSupplementaryView")
        }
        let section = indexPath.section
        let item = data[section]
        header.configureView(titleLabelText: item.headerName)
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].animePosterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.reuseIdentifier, for: indexPath) as? PosterCollectionViewCell else {
            fatalError("Can`t create new cell")
        }
        let section = indexPath.section
        let row = indexPath.row
        let item = data[section].animePosterItems[row]
        if item.image == nil {
            model.requestImage(from: item.imageUrlString) { [weak self] image in
                self?.data[section].animePosterItems[row].image = image
                cell.setImage(image, urlString: item.imageUrlString)
            }
        }
        cell.configureCell(item: item)
        return cell
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension ScheduleContentController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return ScheduleHeaderSupplementaryView.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return PosterCollectionViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension ScheduleContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard !data.isEmpty else { return }
        indexPaths.forEach { indexPath in
            let section = indexPath.section
            let row = indexPath.row
            let item = data[section].animePosterItems[row]
            guard item.image == nil else {
                return
            }
            model.requestImage(from: item.imageUrlString) { [weak self] image in
                self?.data[section].animePosterItems[row].image = image
            }
        }
    }
}

// MARK: - ScheduleModelOutput

extension ScheduleContentController: ScheduleModelOutput {
    func update(data: [ScheduleItem]) {
        self.data = data
        DispatchQueue.main.async {
            self.delegate?.hideSkeletonCollectionView()
            self.delegate?.reloadData()
        }
    }
    
    func failedRequestData(error: Error) {
        print(#function, error)
    }
}

// MARK: - AnimePosterModelOutput

extension ScheduleContentController: ImageModelDelegate {
    func failedRequestImage(error: Error) {
        print(#function, error)
    }
}
