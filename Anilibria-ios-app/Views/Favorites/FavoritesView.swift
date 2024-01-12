//
//  FavoritesView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.01.2024.
//

import UIKit

final class FavoritesView: UIView {
    private let layout = FavoritesCollectionViewLayout().createLayout()
    private (set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let navigationTitleView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Избранное"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .systemRed
        return activityIndicatorView
    }()
    
    init(navigationItem: UINavigationItem) {
        super.init(frame: .zero)
        
        setupView()
        setupNavigationTitleView(navigationItem: navigationItem)
        setupCollectionView()
        setupLayout()
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
        navigationTitleView.addSubview(titleLabel)
        navigationTitleView.addSubview(activityIndicatorView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: navigationTitleView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: navigationTitleView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: navigationTitleView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: navigationTitleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: navigationTitleView.trailingAnchor),

            activityIndicatorView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            activityIndicatorView.trailingAnchor.constraint(equalTo: navigationTitleView.trailingAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
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
    }
}

// MARK: - Internal methods

extension FavoritesView {
    func updateView(withStatus status: FavoritesContentController.Status) {
        switch status {
            case .normal:
                activityIndicatorView.stopAnimating()
            case .loading:
                activityIndicatorView.startAnimating()
            case .error(let message):
                print(message)
        }
    }
}
