//
//  ScheduleContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit
import SkeletonView
import OSLog

protocol ScheduleContentControllerDelegate: AnyObject {
    func didSelectItem(_ rawData: TitleAPIModel, image: UIImage?)
}

@MainActor
final class ScheduleContentController: NSObject {
    weak var delegate: ScheduleContentControllerDelegate?
    
    // MARK: Transition properties
    private (set) var selectedCell: PosterCollectionViewCell?
    private (set) var selectedCellImageViewSnapshot: UIView?
    
    private lazy var model = ScheduleModel()
    
    private let customView: ScheduleView
    private var data: [ScheduleItem] = []
    
    private var status: ScheduleView.Status = .normal {
        didSet {
            customView.updateView(withStatus: status)
        }
    }
    
    init(customView: ScheduleView, delegate: ScheduleContentControllerDelegate?) {
        self.customView = customView
        self.delegate = delegate
        super.init()
        
        setupCollectionView()
        requestData()
    }
}

// MARK: - Private methods

private extension ScheduleContentController {
    func setupCollectionView() {
        customView.collectionView.delegate = self
        customView.collectionView.dataSource = self
        customView.collectionView.prefetchDataSource = self
    }
    
    func cancelRequestImage(indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        guard let item = data[safe: section]?.animePosterItems[safe: row],
                item.image == nil else {
            return
        }
        model.cancelImageTask(forUrlString: item.imageUrlString)
    }
}

// MARK: - Internal methods

extension ScheduleContentController {
    func requestData() {
        guard status != .loading else { return }
        status = .loading
        Task {
            do {
                data = try await model.requestData()
                status = .normal
                customView.collectionView.reloadData()
            } catch {
                let logger = Logger(subsystem: .schedule, category: .data)
                logger.error("\(Logger.logInfo(error: error))")
                status = .error(error)
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelRequestImage(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.animateCellHighlight(at: indexPath, highlighted: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.animateCellHighlight(at: indexPath, highlighted: false)
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
            Task { [weak self] in
                guard let self else { return }
                do {
                    let image = try await self.model.requestImage(fromUrlString: item.imageUrlString)
                    self.data[section].animePosterItems[row].image = image
                    cell.setImage(image, urlString: item.imageUrlString)
                } catch {
                    cell.stopSkeletonAnimation()
                }
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
        return 9
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        3
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension ScheduleContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let section = indexPath.section
            let row = indexPath.row
            guard let item = data[safe: section]?.animePosterItems[safe: row], 
                    item.image == nil else {
                return
            }
            Task { [weak self] in
                guard let self else { return }
                let image = try? await self.model.requestImage(fromUrlString: item.imageUrlString)
                self.data[section].animePosterItems[row].image = image
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cancelRequestImage(indexPath: indexPath)
        }
    }
}
