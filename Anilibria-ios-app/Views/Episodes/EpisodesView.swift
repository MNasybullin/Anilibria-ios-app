//
//  EpisodesView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.10.2023.
//

import UIKit

final class EpisodesView: UIView {
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    init(delegate: EpisodesContentController) {
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

private extension EpisodesView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureTableView(delegate: EpisodesContentController) {
        tableView.delegate = delegate
        tableView.dataSource = delegate
        tableView.prefetchDataSource = delegate
        
        tableView.register(EpisodesTableViewCell.self, forCellReuseIdentifier: EpisodesTableViewCell.reuseIdentifier)
        tableView.register(EpisodesHeaderSupplementaryView.self, forHeaderFooterViewReuseIdentifier: EpisodesHeaderSupplementaryView.reuseIdentifier)
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
