//
//  HomeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit

final class HomeView: UIView {
    enum Section: Int {
        case today
        case updates
    }
    
    enum ElementKind {
        static let sectionHeader = "section-header-element-kind"
    }
    
    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureCollectionView()
        configureRefreshControll()
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension HomeView {
    
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        let layout = HomeCollectionViewLayout().createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            AnimePosterCollectionViewCell.self,
            forCellWithReuseIdentifier: AnimePosterCollectionViewCell.reuseIdentifier)
        collectionView.register(
            HomeHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: ElementKind.sectionHeader,
            withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func configureRefreshControll() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemRed
        collectionView.refreshControl = refreshControl
    }
    
    func configureConstraints() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureSupplementaryViewDataSource() -> DataSource.SupplementaryViewProvider {
        let supplementaryViewProvider: DataSource.SupplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == ElementKind.sectionHeader else { return nil }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier,
                for: indexPath) as? HomeHeaderSupplementaryView else {
                fatalError("Can`t create new header")
            }
            
            switch indexPath.section {
                case Section.today.rawValue:
                    headerView.configureView(
                        titleLabelText: Strings.HomeModule.Title.today,
                        titleButtonText: Strings.HomeModule.ButtonTitle.allDays)
                case Section.updates.rawValue:
                    headerView.configureView(
                        titleLabelText: Strings.HomeModule.Title.updates,
                        titleButtonText: nil)
                default:
                    fatalError("Section is not found")
            }
            return headerView
        }
        return supplementaryViewProvider
    }
}

// MARK: - Internal methods

extension HomeView {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimePosterItem>
    
    func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: -collectionView.adjustedContentInset.top)
        collectionView.setContentOffset(contentOffset, animated: true)
    }
    
    func configureDataSource(cellProvider: @escaping DataSource.CellProvider) -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = configureSupplementaryViewDataSource()
        return dataSource
    }
    
    func configureCollectionViewDelegate(_ contentController: HomeContentController) {
        collectionView.delegate = contentController
    }
    
    func configurePrefetchDataSource(_ contentController: HomeContentController) {
        collectionView.prefetchDataSource = contentController
    }
    
    func addRefreshControllTarget(_ target: Any?, action: Selector) {
        collectionView.refreshControl?.addTarget(target, action: action, for: .valueChanged)
    }
    
    func refreshControlEndRefreshing() {
        DispatchQueue.main.async {
            guard self.collectionView.refreshControl?.isRefreshing == true else { return }
            UIView.animate(withDuration: 1) {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}
