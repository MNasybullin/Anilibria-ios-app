//
//  ScheduleController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit
import SkeletonView

final class ScheduleController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = ScheduleView
    weak var navigator: HomeNavigator?
    
    private lazy var model: ScheduleModel = {
        let model = ScheduleModel()
        model.output = self
        model.scheduleModelOutput = self
        return model
    }()
    private var data: [ScheduleItem]?
    
    override func loadView() {
        view = ScheduleView(collectionViewDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.showSkeletonCollectionView()
        model.requestData()
    }
}

// MARK: - UICollectionViewDelegate

extension ScheduleController: UICollectionViewDelegate {
    // selected cell
}

// MARK: - UICollectionViewDataSource

extension ScheduleController: UICollectionViewDataSource {
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
            model.requestImage(from: item, indexPath: indexPath)
        }
        cell.configureCell(model: item)
        return cell
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension ScheduleController: SkeletonCollectionViewDataSource {
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

extension ScheduleController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let section = indexPath.section
            let row = indexPath.row
            guard let item = data?[section].animePosterItems[row],
                    item.image == nil else {
                return
            }
            model.requestImage(from: item, indexPath: indexPath)
        }
    }
}

// MARK: - ScheduleModelOutput

extension ScheduleController: ScheduleModelOutput {
    func update(data: [ScheduleItem]) {
        self.data = data
        DispatchQueue.main.async {
            self.customView.hideSkeletonCollectionView()
            self.customView.reloadData()
        }
    }
    
    func failedRequestData(error: Error) {
        print(error)
    }
}

// MARK: - AnimePosterModelOutput

extension ScheduleController: AnimePosterModelOutput {
    func updateImage(for item: AnimePosterItem, image: UIImage, indexPath: IndexPath) {
        data?[indexPath.section].animePosterItems[indexPath.row].image = image
        DispatchQueue.main.async {
            self.customView.reconfigureItems(at: [indexPath])
        }
    }
    
    func failedRequestImage(error: Error) {
        print(error)
    }
}
