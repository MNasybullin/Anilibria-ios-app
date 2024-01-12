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
        case history
        case normal
    }
    
    private lazy var searchBar = UISearchBar()
    
    private let randomAnimeView: UIView
    private let resultsView: UIView
    private lazy var historyView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .systemBackground
        return tableView
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
        searchBar.delegate = delegate
        navigationItem.titleView = searchBar
    }
    
    func configureResultsView() {
        resultsView.isHidden = true
    }
    
    func configureLayout() {
        addSubview(randomAnimeView)
        addSubview(historyView)
        addSubview(resultsView)
        
        randomAnimeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            randomAnimeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            randomAnimeView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            randomAnimeView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            randomAnimeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
        ])
        
        historyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            historyView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            historyView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            historyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
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
                historyView.isHidden = true
                resultsView.isHidden = true
            case .history:
                historyView.isHidden = false
                resultsView.isHidden = true
            case .result:
                historyView.isHidden = true
                resultsView.isHidden = false
        }
    }
    
    func searchBarBecomeFirstResponder() {
        searchBar.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        searchBar.endEditing(true)
    }
}
