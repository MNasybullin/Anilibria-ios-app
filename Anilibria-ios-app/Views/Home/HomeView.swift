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
    func refreshButtonDidTapped()
}

@MainActor
final class HomeView: UIView {
    enum Status {
        case loading
        case refresh(animated: Bool = true)
        case normal
        case error(Error)
        
        static func == (lhs: Status, rhs: Status) -> Bool {
            switch (lhs, rhs) {
                case (.normal, .normal),
                    (.loading, .loading),
                    (.refresh, .refresh),
                    (.error, .error):
                    return true
                default:
                    return false
            }
        }
        
        static func != (lhs: Status, rhs: Status) -> Bool {
            return !(lhs == rhs)
        }
    }
    
    let homeCollectionViewLayout = HomeCollectionViewLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: homeCollectionViewLayout.createLayout())
    
    private lazy var errorView: StatusAlertView = {
        let statusView = StatusAlertView()
        let image = UIImage(systemName: Strings.StatusAlertView.Error.image)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        statusView.setImage(image)
        statusView.setTitle(text: Strings.StatusAlertView.Error.title)
        statusView.setActionButton(title: Strings.StatusAlertView.Error.refreshButtonTitle, for: .normal)
        statusView.setActionButton(action: UIAction(handler: { [weak self] _ in
            self?.delegate?.refreshButtonDidTapped()
        }), for: .touchUpInside)
        return statusView
    }()
    
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
        
        addSubview(errorView)
        errorView.setupFullScreenConstraints(to: self)
    }
    
    func showSkeletonCollectionView() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideSkeletonCollectionView() {
        if collectionView.sk.isSkeletonActive {
            collectionView.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
    }
    
    func beginRefreshing() {
        guard collectionView.refreshControl?.isRefreshing == false else {
            return
        }
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
            self.scrollToTop(animated: false)
        }
    }
    
    func refreshControlEndRefreshing() {
        guard collectionView.refreshControl?.isRefreshing == true else {
            return
        }
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
            self.scrollSectionsToTop()
        }
    }
    
    func scrollSectionsToTop() {
        for section in 0..<collectionView.numberOfSections {
            let indexPath = IndexPath(row: 0, section: section)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - Targets

private extension HomeView {
    @objc func handleRefreshControll() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        delegate?.handleRefreshControl()
    }
}

// MARK: - Internal methods

extension HomeView {
    func scrollToTop(animated: Bool = true) {
        let topOffset = CGPoint(x: 0, y: -collectionView.adjustedContentInset.top)
        collectionView.setContentOffset(topOffset, animated: animated)
    }
    
    func updateView(withStatus status: Status) {
        switch status {
            case .loading:
                errorView.isHidden = true
                collectionView.isHidden = false
                showSkeletonCollectionView()
            case .refresh(let animated):
                errorView.isHidden = true
                collectionView.isHidden = false
                if animated {
                    beginRefreshing()
                }
            case .normal:
                errorView.isHidden = true
                collectionView.isHidden = false
                refreshControlEndRefreshing()
                hideSkeletonCollectionView()
            case .error(let error):
                errorView.isHidden = false
                collectionView.isHidden = true
                refreshControlEndRefreshing()
                errorView.setMessage(text: error.localizedDescription)
        }
    }
}
