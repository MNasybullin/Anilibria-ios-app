//
//  HomeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit
import SkeletonView

protocol HomeViewOutput: AnyObject {
    func handleRefreshControl()
}

final class HomeView: UIView {
    enum Section: Int, CaseIterable {
        case today
        case updates
        case youtube
    }
    
    enum ElementKind {
        static let sectionHeader = "section-header-element-kind"
    }
    
    private var collectionView: UICollectionView!
    
    weak var delegate: HomeViewOutput?
    
    init(delegate: HomeController, collectionViewDelegate: HomeContentController) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        configureView()
        configureCollectionView(delegate: collectionViewDelegate)
        configureRefreshControll()
        
        configureLayout()
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
    
    func configureCollectionView(delegate: HomeContentController) {
        let layout = HomeCollectionViewLayout().createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            HomePosterCollectionViewCell.self,
            forCellWithReuseIdentifier: HomePosterCollectionViewCell.reuseIdentifier)
        collectionView.register(
            HorizontalHomePosterCell.self,
            forCellWithReuseIdentifier: HorizontalHomePosterCell.reuseIdentifier)
        collectionView.register(
            HomeHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: ElementKind.sectionHeader,
            withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isSkeletonable = true
        
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.prefetchDataSource = delegate
    }
    
    func configureRefreshControll() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemRed
        refreshControl.addTarget(self, action: #selector(handleRefreshControll), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func configureLayout() {
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Targets

private extension HomeView {
    @objc func handleRefreshControll() {
        delegate?.handleRefreshControl()
    }
}

// MARK: - Internal methods

extension HomeView {
    func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: -collectionView.adjustedContentInset.top)
        collectionView.setContentOffset(contentOffset, animated: true)
    }
    
    func refreshControlEndRefreshing() {
        guard self.collectionView.refreshControl?.isRefreshing == true else {
            return
        }
        UIView.animate(withDuration: 1) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func programaticallyBeginRefreshing() {
        collectionView.refreshControl?.beginRefreshing()
        scrollToTop()
        delegate?.handleRefreshControl()
    }
    
    func showSkeletonCollectionView() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideSkeletonCollectionView() {
        collectionView.hideSkeleton(reloadDataAfter: false)
    }
    
    func reloadSection(numberOfSection: Int) {
        collectionView.reloadSections(IndexSet(integer: numberOfSection))
    }
}
