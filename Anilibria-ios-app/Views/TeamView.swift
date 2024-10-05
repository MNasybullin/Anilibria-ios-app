//
//  TeamView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.02.2024.
//

import UIKit

final class TeamView: UIView {
    
    private(set) lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension TeamView {
    func setupView() {
        backgroundColor = .systemBackground
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
    
    func setupLayout() {
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
