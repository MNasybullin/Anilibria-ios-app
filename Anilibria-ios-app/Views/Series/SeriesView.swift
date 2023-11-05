//
//  SeriesView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.10.2023.
//

import UIKit

final class SeriesView: UIView {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    init(delegate: SeriesContentController) {
        super.init(frame: .zero)
        
        configureView()
        configureTableView(delegate: delegate)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private methods

private extension SeriesView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureTableView(delegate: SeriesContentController) {
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.prefetchDataSource = delegate
        
        tableView.register(SeriesTableViewCell.self, forCellReuseIdentifier: SeriesTableViewCell.reuseIdentifier)
        tableView.register(SeriesHeaderSupplementaryView.self, forHeaderFooterViewReuseIdentifier: SeriesHeaderSupplementaryView.reuseIdentifier)
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
}
