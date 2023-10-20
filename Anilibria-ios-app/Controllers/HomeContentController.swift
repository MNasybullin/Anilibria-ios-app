//
//  HomeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.10.2023.
//

import UIKit

protocol HomeTodayContentControllerDelegate: AnyObject {
    func update(todayData: [HomeModel])
    func update(todayImage image: UIImage, for indexPath: IndexPath)
}

protocol HomeUpdatesContentControllerDelegate: AnyObject {
    func update(updatesData: [HomeModel])
    func update(updatesImage image: UIImage, for indexPath: IndexPath)
}

final class HomeContentController: NSObject {
    typealias ElementKind = HomeView.ElementKind
    typealias Section = HomeView.Section
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeModel>
    
    private var homeTodayModel = HomeTodayModel()
    private var homeUpdatesModel = HomeUpdatesModel()
    
    private var dataSource: DataSource!
    
    private var todayData: [HomeModel] = []
    private var updatesData: [HomeModel] = []
    
    override init() {
        super.init()
        homeTodayModel.delegate = self
        homeUpdatesModel.delegate = self
        
        homeTodayModel.requestData()
        homeUpdatesModel.requestData()
    }
}

// MARK: - Private methods

private extension HomeContentController {
    func configureSupplementaryViewDataSource() {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == ElementKind.sectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier,
                    for: indexPath) as? HomeHeaderSupplementaryView else {
                    fatalError("Can`t create new header")
                }
                let labelText: String?
                let buttonText: String?
                
                switch indexPath.section {
                    case Section.today.rawValue:
                        labelText = "Сегодня"
                        buttonText = "Все"
                    case Section.updates.rawValue:
                        labelText = "Тест"
                        buttonText = nil
                    default:
                        fatalError("Section not found.")
                }
                headerView.configureView(titleLabelText: labelText,
                                         titleButtonText: buttonText)
                return headerView
            }
            return nil
        }
    }
    
    func initialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.today, .updates])
        snapshot.appendItems(todayData, toSection: .today)
        snapshot.appendItems(updatesData, toSection: .updates)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func applyTodaySnapshot() {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(self.todayData, toSection: .today)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func applyUpdatesSnapshot() {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(self.updatesData, toSection: .updates)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
        
    func reconfigureSnapshot(model: HomeModel) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.reconfigureItems([model])
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func requestImage(for model: HomeModel, indexPath: IndexPath) {
        switch indexPath.section {
            case Section.today.rawValue:
                homeTodayModel.getImage(for: model.imageUrlString, indexPath: indexPath)
            case Section.updates.rawValue:
                homeUpdatesModel.getImage(for: model.imageUrlString, indexPath: indexPath)
            default:
                fatalError("Not found section")
        }
    }
}

// MARK: - Internal methods

extension HomeContentController {
    func configureCellProvider() -> DataSource.CellProvider {
        let cellProvider: DataSource.CellProvider = { (collectionView, indexPath, model) in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PosterCollectionViewCell else {
                fatalError("Can`t create new cell")
            }
            if model.image == nil {
                self.requestImage(for: model, indexPath: indexPath)
            }
            cell.configureCell(model: model)
            return cell
        }
        return cellProvider
    }
    
    func configureDataSource(_ dataSource: DataSource) {
        self.dataSource = dataSource
        configureSupplementaryViewDataSource()
        initialSnapshot()
    }
}

// MARK: -

extension HomeContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath) selected")
    }
}

// MARK: - HomeTodayContentControllerDelegate

extension HomeContentController: HomeTodayContentControllerDelegate {
    func update(todayData: [HomeModel]) {
        self.todayData = todayData
        applyTodaySnapshot()
    }
        
    func update(todayImage image: UIImage, for indexPath: IndexPath) {
        todayData[indexPath.row].image = image
        reconfigureSnapshot(model: todayData[indexPath.row])
    }
}

// MARK: - HomeUpdatesContentControllerDelegate

extension HomeContentController: HomeUpdatesContentControllerDelegate {
    func update(updatesData: [HomeModel]) {
        self.updatesData = updatesData
        applyUpdatesSnapshot()
    }
    
    func update(updatesImage image: UIImage, for indexPath: IndexPath) {
        updatesData[indexPath.row].image = image
        reconfigureSnapshot(model: updatesData[indexPath.row])
    }
}
