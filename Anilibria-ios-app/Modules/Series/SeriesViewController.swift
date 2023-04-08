//
//  SeriesViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import UIKit

protocol SeriesViewProtocol: AnyObject {
	var presenter: SeriesPresenterProtocol! { get set }
    
    func update(_ image: UIImage?, for indexPath: IndexPath)
}

final class SeriesViewController: UIViewController, SeriesViewProtocol {
	var presenter: SeriesPresenterProtocol!
    
    private var tableView: UITableView!
    private let cellIdentifier = "SeriesTableViewCell"
    private var data: AnimeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = presenter.getData()
        configureNavigationBar()
        setupTableView()
    }
    
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(SeriesTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        
        setupTableViewHeader()
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
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
        label.text = (data.series?.string ?? "") + " " + "серий"
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
    
    func update(_ image: UIImage?, for indexPath: IndexPath) {
        if image == nil {
            self.data.playlist[indexPath.row].imageIsLoading = false
            return
        }
        self.data.playlist[indexPath.row].image = image
        self.data.playlist[indexPath.row].imageIsLoading = false
        DispatchQueue.main.async {
            self.tableView.reconfigureRows(at: [indexPath])
        }
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
        return data.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SeriesTableViewCell else {
            fatalError("Cell is doesn`t SeriesTableViewCell")
        }
        
        let rowData = data.playlist[indexPath.row]
        cell.titleLabel.text = rowData.serieString
        cell.subtitleLabel.text = rowData.createdDateString
        
        guard let image = rowData.image else {
            if rowData.imageIsLoading == false && NetworkMonitor.shared.isConnected == true {
                data.playlist[indexPath.row].imageIsLoading = true
                presenter.getImage(forIndexPath: indexPath)
            }
            cell.seriesImageView.image = UIImage(asset: Asset.Assets.blankImage)
            return cell
        }
        
        cell.seriesImageView.image = image
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension SeriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if data.playlist[indexPath.row].image == nil && data.playlist[indexPath.row].imageIsLoading == false && NetworkMonitor.shared.isConnected == true {
                data.playlist[indexPath.row].imageIsLoading = true
                presenter.getImage(forIndexPath: indexPath)
            }
        }
    }
}
