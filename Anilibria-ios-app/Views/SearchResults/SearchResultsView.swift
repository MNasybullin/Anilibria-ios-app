//
//  SearchResultsView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.11.2023.
//

import UIKit
import SkeletonView

final class SearchResultsView: UIView {
    typealias Status = SearchResultsController.Status
    
    private var tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var headerView: SearchResultsHeaderView = {
        let view = SearchResultsHeaderView()
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        view.frame.size.height = size.height
        return view
    }()
    
    private lazy var loadingFooterView: SearchResultsLoadingFooterView = {
        let view = SearchResultsLoadingFooterView()
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        view.frame.size.height = size.height
        return view
    }()
    
    private lazy var errorFooterView: SearchResultsErrorFooterView = {
        let view = SearchResultsErrorFooterView()
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        view.frame.size.height = size.height
        return view
    }()
    
    init(delegate: SearchResultsController) {
        super.init(frame: .zero)
        
        errorFooterView.delegate = delegate
        configureView()
        configureTableView(delegate: delegate)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private methods

private extension SearchResultsView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureTableView(delegate: SearchResultsController) {
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.prefetchDataSource = delegate
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: SearchResultsTableViewCell.reuseIdentifier)
        
        tableView.isSkeletonable = true
    }
    
    func configureLayout() {
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateTableView(header: UIView?) {
        tableView.performBatchUpdates {
            if tableView.tableHeaderView != header {
                tableView.tableHeaderView = header
            }
        }
    }
    
    func updateTableView(footer: UIView?) {
        tableView.performBatchUpdates {
            if tableView.tableFooterView != footer {
                tableView.tableFooterView = footer
            }
        }
    }
}

// MARK: - Internal methods

extension SearchResultsView {
    func showTableViewSkeleton() {
        tableView.showAnimatedSkeleton()
    }
    
    func hideTableViewSkeleton() {
        if tableView.sk.isSkeletonActive == true {
            tableView.hideSkeleton(reloadDataAfter: false)
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func insertRows(indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .top)
        }
    }
    
    func updateHeaderFooterView(status: Status) {
        switch status {
            case .notFound:
                updateTableView(header: headerView)
                updateTableView(footer: nil)
            case .loadingMore:
                updateTableView(header: nil)
                updateTableView(footer: loadingFooterView)
                loadingFooterView.startActivityIndicator()
            case .loadingMoreFail:
                updateTableView(header: nil)
                updateTableView(footer: errorFooterView)
            case .skeleton:
                updateTableView(header: nil)
                updateTableView(footer: nil)
                showTableViewSkeleton()
            case .normal:
                updateTableView(header: nil)
                updateTableView(footer: nil)
        }
    }
}
