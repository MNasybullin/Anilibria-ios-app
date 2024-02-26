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
    let homeCollectionViewLayout = HomeCollectionViewLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: homeCollectionViewLayout.createLayout())
    
    weak var delegate: HomeViewOutput?
    
    init(delegate: HomeController) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        configureView()
        setupCollectionView()
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
    
    func setupCollectionView() {
        // For SkeletonView
        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier)
        
        collectionView.register(
            TodayHomePosterCollectionCell.self,
            forCellWithReuseIdentifier: TodayHomePosterCollectionCell.reuseIdentifier)
        collectionView.register(
            WatchingHomeCollectionViewCell.self,
            forCellWithReuseIdentifier: WatchingHomeCollectionViewCell.reuseIdentifier)
        collectionView.register(
            UpdatesHomePosterCollectionCell.self,
            forCellWithReuseIdentifier: UpdatesHomePosterCollectionCell.reuseIdentifier)
        collectionView.register(
            YouTubeHomePosterCollectionCell.self,
            forCellWithReuseIdentifier: YouTubeHomePosterCollectionCell.reuseIdentifier)
        collectionView.register(
            HomeHeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderSupplementaryView.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isSkeletonable = true
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
        let topOffset = CGPoint(x: 0, y: -collectionView.adjustedContentInset.top)
        collectionView.setContentOffset(topOffset, animated: true)
    }
    
    func refreshControlEndRefreshing() {
        guard collectionView.refreshControl?.isRefreshing == true else {
            return
        }
        scrollSectionsToTop()
        collectionView.refreshControl?.endRefreshing()
    }
    
    func scrollSectionsToTop() {
        for section in 0..<collectionView.numberOfSections {
            let indexPath = IndexPath(row: 0, section: section)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    func programaticallyBeginRefreshing() {
        collectionView.refreshControl?.beginRefreshing()
        delegate?.handleRefreshControl()
    }
    
    func showSkeletonCollectionView() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideSkeletonCollectionView() {
        if collectionView.sk.isSkeletonActive {
            collectionView.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
    }
}
