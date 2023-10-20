//
//  HomeContentController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.10.2023.
//

import UIKit

protocol HomeContentControllerDelegate: AnyObject {
    func update(data: [HomeModel], from section: HomeContentController.Section)
    func reconfigure(data: HomeModel)
}

final class HomeContentController: NSObject {
    typealias ElementKind = HomeView.ElementKind
    typealias Section = HomeView.Section
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeModel>
    
    private var homeTodayModel: HomeModelController = HomeTodayModelController()
    private var homeUpdatesModel: HomeModelController = HomeUpdatesModelController()
    
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
    
    func applySnapshot(for section: Section) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            switch section {
                case .today:
                    snapshot.appendItems(self.todayData, toSection: section)
                case .updates:
                    snapshot.appendItems(self.updatesData, toSection: section)
            }
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
                homeTodayModel.getImage(for: model)
            case Section.updates.rawValue:
                homeUpdatesModel.getImage(for: model)
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

// MARK: - UICollectionViewDelegate

extension HomeContentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell \(indexPath) selected")
    }
}

// MARK: - HomeContentControllerDelegate

extension HomeContentController: HomeContentControllerDelegate {
    func update(data: [HomeModel], from section: Section) {
        switch section {
            case .today:
                todayData = data
            case .updates:
                updatesData = data
        }
        applySnapshot(for: section)
    }
    
    func reconfigure(data: HomeModel) {
        reconfigureSnapshot(model: data)
    }
}
