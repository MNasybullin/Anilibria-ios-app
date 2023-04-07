//
//  SeriesViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import UIKit

protocol SeriesViewProtocol: AnyObject {
	var presenter: SeriesPresenterProtocol! { get set }
}

final class SeriesViewController: UIViewController, SeriesViewProtocol {
	var presenter: SeriesPresenterProtocol!
    
    private var tableView: UITableView!
    private let cellIdentifier = "SeriesTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(SeriesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        setupTableViewHeader()
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableViewConstraints()
    }
    
    private func setupTableViewHeader() {
        let header = UIView()
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        
        header.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: header.layoutMarginsGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: header.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: header.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: header.layoutMarginsGuide.bottomAnchor)
        ])
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "16 серий"
        label.textColor = .secondaryLabel
        stack.addArrangedSubview(label)
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        header.frame.size.height = size.height
        tableView.tableHeaderView = header
    }
    
    private func tableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension SeriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("series cell clicked")
    }
}

// MARK: - UITableViewDataSource
extension SeriesViewController: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SeriesTableViewCell else {
            fatalError("Cell is doesn`t SeriesTableViewCell")
        }
        
        return cell
    }
}
