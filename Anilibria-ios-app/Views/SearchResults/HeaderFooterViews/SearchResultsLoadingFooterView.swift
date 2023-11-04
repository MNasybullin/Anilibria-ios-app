//
//  SearchResultsLoadingFooterView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 11.03.2023.
//

import UIKit

final class SearchResultsLoadingFooterView: UIView {
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SearchResultsLoadingFooterView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: - Internal methods

extension SearchResultsLoadingFooterView {
    func startActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
