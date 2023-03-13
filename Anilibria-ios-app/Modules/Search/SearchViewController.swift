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
    func updateRandomAnimeView(withData data: RandomAnimeViewModel)
}

final class SearchViewController: UIViewController {
    var presenter: SearchPresenterProtocol!
    var searchController: UISearchController!
    
    private var randomAnimeView: RandomAnimeView!
    private var searchResultsTableView: AnimeTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureNavigationItem()
        configureRandomAnimeView()
        configureSearchResultsTableView()
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = true
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureRandomAnimeView() {
        randomAnimeView = RandomAnimeView(frame: .zero)
//        randomAnimeView.delegate = self
//        getRandomAnimeData()
//        randomAnimeView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(randomAnimeView)
//
//        NSLayoutConstraint.activate([
//            randomAnimeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            randomAnimeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            randomAnimeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            randomAnimeView.heightAnchor.constraint(equalToConstant: 250)
//        ])
    }
    
    private func configureSearchResultsTableView() {
        searchResultsTableView = AnimeTableView(heightForRow: 150)
        searchResultsTableView.isUserInteractionEnabled = true
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchResultsTableView)
        searchResultsTableView.isHidden = false
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
    
    func getData(after: Int) {
        presenter.getData()
    }
}

extension SearchViewController: RandomAnimeViewDelegate {
    func getRandomAnimeData() {
        presenter.getRandomAnimeData()
    }
    
    func updateConstraints() {
        updateViewConstraints()
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func showErrorAlert(with title: String, message: String) {
        Alert.showErrorAlert(on: self, with: title, message: message)
    }
    
    func update(data: [AnimeTableViewModel]) {
        searchResultsTableView.update(data)
    }
    
    func update(image: UIImage, for indexPath: IndexPath) {
        searchResultsTableView.update(image, for: indexPath)
    }
    
    func updateRandomAnimeView(withData data: RandomAnimeViewModel) {
        randomAnimeView.update(data: data)
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
