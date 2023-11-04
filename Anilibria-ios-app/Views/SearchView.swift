//
//  SearchView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

final class SearchView: UIView {
    enum Status {
        case result
        case search
        case normal
    }
    
    private lazy var searchBar = UISearchBar()
    
    private let randomAnimeView: UIView
    private let resultsView: UIView
    private lazy var searchView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .systemBackground
        return view
    }()
    
    init(delegate: SearchController, randomAnimeView: UIView, resultsView: UIView, navigationItem: UINavigationItem) {
        self.randomAnimeView = randomAnimeView
        self.resultsView = resultsView
        super.init(frame: .zero)
        
        configureView()
        configureSearchBar(delegate: delegate, navigationItem: navigationItem)
        configureResultsView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SearchView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureSearchBar(delegate: SearchController, navigationItem: UINavigationItem) {
        searchBar.placeholder = Strings.SearchModule.SearchBar.placeholder
//        searchBar.isTranslucent = false
        searchBar.delegate = delegate
        navigationItem.titleView = searchBar
    }
    
    func configureResultsView() {
        resultsView.isHidden = true
    }
    
    func configureLayout() {
        addSubview(randomAnimeView)
        addSubview(searchView)
        addSubview(resultsView)
        
        randomAnimeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            randomAnimeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            randomAnimeView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            randomAnimeView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            randomAnimeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resultsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Internal methods

extension SearchView {
    func updateView(status: Status) {
        switch status {
            case .normal:
                randomAnimeView.isHidden = false
                searchView.isHidden = true
                resultsView.isHidden = true
            case .search:
                randomAnimeView.isHidden = true
                searchView.isHidden = false
                resultsView.isHidden = true
            case .result:
                randomAnimeView.isHidden = true
                searchView.isHidden = true
                resultsView.isHidden = false
        }
    }
    
    func searchBarBecomeFirstResponder() {
        searchBar.becomeFirstResponder()
    }
}
