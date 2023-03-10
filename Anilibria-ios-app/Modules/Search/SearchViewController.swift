//
//  SearchViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.01.2023.
//

import Foundation
import UIKit

protocol SearchViewProtocol: AnyObject {
    var presenter: SearchPresenterProtocol! { get set }
    
    func showErrorAlert(with title: String, message: String)
    func update(data: [AnimeTableViewModel])
    func update(image: UIImage, for indexPath: IndexPath)
}

final class SearchViewController: UIViewController {
    var presenter: SearchPresenterProtocol!
    var searchController: UISearchController!
    
    var searchResultsTableView: AnimeTableView = {
        let tableView = AnimeTableView(heightForRow: 150)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureNavigationItem()
        configureTableView()
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.definesPresentationContext = true
//        searchController.obscuresBackgroundDuringPresentation = true проверить
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        view.addSubview(searchResultsTableView)
        
        searchResultsTableView.animeTableViewDelegate = self
        
        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
//        print("updateSearchResults")
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
}

// MARK: - UISearchControllerDelegate
extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        print("Present")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("Dismiss")
    }
}

// MARK: - AnimeTableViewDelegate
extension SearchViewController: AnimeTableViewDelegate {
    func getImage(forIndexPath indexPath: IndexPath) {
        presenter.getImage(forIndexPath: indexPath)
    }
    
    func getData() {
        presenter.getData()
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func showErrorAlert(with title: String, message: String) {
        Alert.showErrorAlert(on: self, with: title, message: message)
    }
    
    func update(data: [AnimeTableViewModel]) {
        searchResultsTableView.updateData(data)
    }
    
    func update(image: UIImage, for indexPath: IndexPath) {
        searchResultsTableView.updateImage(image, for: indexPath)
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct SearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            SearchRouter.start().entry
        }
    }
}

#endif
