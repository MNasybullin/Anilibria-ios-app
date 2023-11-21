//
//  HomeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit
import SkeletonView

protocol HomeContentControllerDelegate: AnyObject {
    func todayHeaderButtonTapped()
    func refreshControlEndRefreshing()
    func showSkeletonCollectionView()
    func hideSkeletonCollectionView()
    func reloadSection(numberOfSection: Int)
    func didSelectItem(_ rawData: TitleAPIModel, image: UIImage?)
}

final class HomeContentController: NSObject {
    typealias Section = HomeView.Section
    
    weak var delegate: HomeContentControllerDelegate?
    
    private var data: [[AnimePosterItem]] = .init(repeating: [], count: 2)
    private lazy var models: [HomeModelInput] = {
        let todayModel = HomeTodayModel()
        todayModel.imageModelDelegate = self
        todayModel.homeModelOutput = self
        
        let updatesModel = HomeUpdatesModel()
        updatesModel.imageModelDelegate = self
        updatesModel.homeModelOutput = self
        return [todayModel, updatesModel]
    }()
    
    private var isSkeletonView: Bool
    
    init(delegate: HomeContentControllerDelegate?) {
        self.delegate = delegate
        isSkeletonView = true
        super.init()
    }
    
    func requestInitialData() {
        isSkeletonView = true
        delegate?.showSkeletonCollectionView()
        models.forEach {
            $0.requestData()
        }
    }
    
    func requestRefreshData() {
        guard models[Section.today.rawValue].isDataTaskLoading == false && models[Section.updates.rawValue].isDataTaskLoading == false else {
            delegate?.refreshControlEndRefreshing()
            return
        }
        models.forEach { $0.requestData() }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        guard let rawData = models[section].getRawData(row: row) else {
            return
        }
        let image = data[section][row].image
        delegate?.didSelectItem(rawData, image: image)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeContentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier, for: indexPath) as? HomeHeaderSupplementaryView else {
            fatalError("Header is not HomeHeaderSupplementaryView")
        }
        
        switch indexPath.section {
            case Section.today.rawValue:
                header.configureView(
                    titleLabelText: Strings.HomeModule.Title.today,
                    titleButtonText: Strings.HomeModule.ButtonTitle.allDays) { [weak self] in
                        self?.delegate?.todayHeaderButtonTapped()
                    }
            case Section.updates.rawValue:
                header.configureView(titleLabelText: Strings.HomeModule.Title.updates)
            default:
                fatalError("Section is not found")
        }
        return header
    }
    
    // For Skeleton
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return data.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items: Int
        if data[section].isEmpty {
            items = 5
        } else {
            items = data[section].count
        }
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimePosterCollectionViewCell.reuseIdentifier, for: indexPath) as? AnimePosterCollectionViewCell else {
            fatalError("Can`t create new cell")
        }
        let section = indexPath.section
        let row = indexPath.row
        guard data[section].isEmpty == false else {
            cell.configureSkeletonCell()
            return cell
        }
        let item = data[section][row]
        if item.image == nil {
            models[section].requestImage(from: item.imageUrlString) { [weak self] image in
                self?.data[section][row].image = image
                cell.setImage(image, urlString: item.imageUrlString)
            }
        }
        cell.configureCell(item: item)
        return cell
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension HomeContentController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return HomeHeaderSupplementaryView.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return AnimePosterCollectionViewCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension HomeContentController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let section = indexPath.section
            let row = indexPath.row
            guard data[section].isEmpty == false,
                    data[section][row].image == nil else { return }
            let item = data[section][row]
            models[section].requestImage(from: item.imageUrlString) { [weak self] image in
                self?.data[section][row].image = image
            }
        }
    }
}

// MARK: - HomeModelOutput

extension HomeContentController: HomeModelOutput {
    func updateData(items: [AnimePosterItem], section: HomeView.Section) {
        DispatchQueue.main.async { [self] in
            data[section.rawValue] = items
            if isSkeletonView {
                delegate?.hideSkeletonCollectionView()
                isSkeletonView = false
            }
            delegate?.reloadSection(numberOfSection: section.rawValue)
            delegate?.refreshControlEndRefreshing()
        }
    }
    
    func failedRequestData(error: Error) {
        DispatchQueue.main.async {
            self.delegate?.refreshControlEndRefreshing()
        }
    }
}

// MARK: - AnimePosterModelOutput

extension HomeContentController: ImageModelDelegate {
    func failedRequestImage(error: Error) {
        print(#function, error)
    }
}