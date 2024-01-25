//
//  FavoritesView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.01.2024.
//

import UIKit

final class FavoritesView: UIView {
    typealias LocalizableString = Strings.FavoritesModule
    
    private let layout = FavoritesCollectionViewLayout().createLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let navigationTitleView = UIView()
    
    private lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableString.navTitle
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .systemRed
        return activityIndicatorView
    }()
    
    private lazy var errorView: StatusAlertView = {
        let statusView = StatusAlertView()
        let image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        statusView.setImage(image)
        statusView.setTitle(text: LocalizableString.ErrorView.title)
        statusView.setActionButton(title: LocalizableString.ErrorView.actionButton, for: .normal)
        return statusView
    }()
    
    private lazy var favoritesEmptyView: StatusAlertView = {
        let statusView = StatusAlertView()
        let image = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        statusView.setImage(image)
        statusView.setTitle(text: LocalizableString.FavoritesEmptyView.title)
        statusView.setMessage(text: LocalizableString.FavoritesEmptyView.message)
        statusView.actionButtonIsHidden = true
        return statusView
    }()
    
    private lazy var noUserView: StatusAlertView = {
        let statusView = StatusAlertView()
        let image = UIImage(systemName: "person.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        statusView.setImage(image)
        statusView.setTitle(text: LocalizableString.NoUserView.title)
        statusView.setMessage(text: LocalizableString.NoUserView.message)
        statusView.setActionButton(title: LocalizableString.NoUserView.actionButton, for: .normal)
        return statusView
    }()
    
    init(navigationItem: UINavigationItem) {
        super.init(frame: .zero)
        
        setupView()
        setupNavigationTitleView(navigationItem: navigationItem)
        setupCollectionView()
        setupLayout()
        updateView(withStatus: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension FavoritesView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupNavigationTitleView(navigationItem: UINavigationItem) {
        navigationTitleView.addSubview(navTitleLabel)
        navigationTitleView.addSubview(activityIndicatorView)
        
        navTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navTitleLabel.topAnchor.constraint(equalTo: navigationTitleView.topAnchor),
            navTitleLabel.bottomAnchor.constraint(equalTo: navigationTitleView.bottomAnchor),
            navTitleLabel.centerXAnchor.constraint(equalTo: navigationTitleView.centerXAnchor),
            navTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: navigationTitleView.leadingAnchor),
            navTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: navigationTitleView.trailingAnchor),

            activityIndicatorView.leadingAnchor.constraint(equalTo: navTitleLabel.trailingAnchor, constant: 8),
            activityIndicatorView.trailingAnchor.constraint(equalTo: navigationTitleView.trailingAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: navTitleLabel.centerYAnchor)
        ])
        navigationItem.titleView = navigationTitleView
    }
    
    func setupCollectionView() {
        collectionView.register(
            HomePosterCollectionViewCell.self,
            forCellWithReuseIdentifier: HomePosterCollectionViewCell.reuseIdentifier)
        
        collectionView.isSkeletonable = true
    }
    
    func setupLayout() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        [errorView, favoritesEmptyView, noUserView].forEach {
            addSubview($0)
            $0.setupFullScreenConstraints(to: self)
        }
    }
    
    func showOnly(view: UIView) {
        view.isHidden = false
        subviews.forEach {
            if $0 != view {
                $0.isHidden = true
            }
        }
    }
}

// MARK: - Internal methods

extension FavoritesView {
    func updateView(withStatus status: FavoritesContentController.Status) {
        switch status {
            case .normal:
                activityIndicatorView.stopAnimating()
                showOnly(view: collectionView)
            case .loading:
                activityIndicatorView.startAnimating()
                showOnly(view: collectionView)
            case .favoritesIsEmpty:
                activityIndicatorView.stopAnimating()
                showOnly(view: favoritesEmptyView)
            case .userIsNotAuthorized:
                activityIndicatorView.stopAnimating()
                showOnly(view: noUserView)
            case .error(let error):
                activityIndicatorView.stopAnimating()
                errorView.setMessage(text: (error as NSError).description + error.localizedDescription)
                showOnly(view: errorView)
        }
    }
    
    func setActionForErrorView(action: UIAction, for event: UIControl.Event) {
        errorView.setActionButton(action: action, for: event)
    }
    
    func setActionForNoUserView(action: UIAction, for event: UIControl.Event) {
        noUserView.setActionButton(action: action, for: event)
    }
    
    func showCollectionViewSkeleton() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideCollectionViewSkeleton() {
        if collectionView.sk.isSkeletonActive {
            collectionView.hideSkeleton(reloadDataAfter: false, transition: .none)
        }
    }
}
