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
    func reconfigureItems(at indexPaths: [IndexPath])
    func didSelectItem(_ rawData: TitleAPIModel)
}

final class ScheduleContentController: NSObject {
    weak var delegate: ScheduleContentControllerDelegate?
    
    private lazy var model: ScheduleModel = {
        let model = ScheduleModel()
        model.output = self
        model.scheduleModelOutput = self
        return model
    }()
    
    private var data: [ScheduleItem]?
    
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
        delegate?.didSelectItem(rawData)
    }
}

// MARK: - UICollectionViewDataSource

extension ScheduleContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScheduleHeaderSupplementaryView.reuseIdentifier, for: indexPath) as? ScheduleHeaderSupplementaryView else {
            fatalError("Header is not ScheduleHeaderSupplementaryView")
        }
        let section = indexPath.section
        if let item = data?[section] {
            header.configureView(titleLabelText: item.headerName)
        }
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        data?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?[section].animePosterItems.count ?? 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimePosterCollectionViewCell.reuseIdentifier, for: indexPath) as? AnimePosterCollectionViewCell else {
            fatalError("Can`t create new cell")
        }
        let section = indexPath.section
        let row = indexPath.row
        guard let item = data?[section].animePosterItems[row] else {
            return cell
        }
        if item.image == nil {
            model.requestImage(from: item.imageUrlString, indexPath: indexPath)
        }
        cell.configureCell(model: item)
        return cell
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension ScheduleContentController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return ScheduleHeaderSupplementaryView.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return AnimePosterCollectionViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension ScheduleContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let section = indexPath.section
            let row = indexPath.row
            guard let item = data?[section].animePosterItems[row],
                    item.image == nil else {
                return
            }
            model.requestImage(from: item.imageUrlString, indexPath: indexPath)
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

extension ScheduleContentController: AnimePosterModelOutput {
    func update(image: UIImage, indexPath: IndexPath) {
        data?[indexPath.section].animePosterItems[indexPath.row].image = image
        DispatchQueue.main.async {
            self.delegate?.reconfigureItems(at: [indexPath])
        }
    }
    
    func failedRequestImage(error: Error) {
        print(#function, error)
    }
}
