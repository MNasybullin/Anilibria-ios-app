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
    
    func showSearchResultsErrorFooterView(with message: String)
    func showErrorAlert(with title: String, message: String)
    func updateSearchResultsTableView(data: [SearchResultsModel])
    func addMoreSearchResultsTableView(data: [SearchResultsModel], needLoadMoreData: Bool)
    func updateSearchResultsTableView(image: UIImage?, for indexPath: IndexPath)
    func updateRandomAnimeView(withData data: RandomAnimeViewModel)
}

final class SearchViewController: UIViewController {
    var presenter: SearchPresenterProtocol!
    var searchBar: UISearchBar!
    
    private var randomAnimeView: RandomAnimeView!
    private var searchResultsTableView: SearchResultsTableView!
    
    var textEditingTimer: Timer?
    var lastSearchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureSearchBar()
        configureRandomAnimeView()
        configureSearchResultsTableView()
    }
    
    private func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = Strings.SearchModule.SearchBar.placeholder
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func configureRandomAnimeView() {
        randomAnimeView = RandomAnimeView(frame: .zero)
        randomAnimeView.delegate = self
        getRandomAnimeData()
        randomAnimeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(randomAnimeView)

        NSLayoutConstraint.activate([
            randomAnimeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            randomAnimeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            randomAnimeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            randomAnimeView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func configureSearchResultsTableView() {
        searchResultsTableView = SearchResultsTableView(heightForRow: 150)
        searchResultsTableView.isUserInteractionEnabled = true
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchResultsTableView)
        searchResultsTableView.isHidden = true
        searchResultsTableView.searchResultsTableViewDelegate = self

        NSLayoutConstraint.activate([
            searchResultsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func deleteSearchResultsData() {
        presenter.cancellTasks()
        presenter.deleteSearchResultsData()
        searchResultsTableView.deleteData()
        searchResultsTableView.hideSkeleton(reloadDataAfter: false)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        deleteSearchResultsData()
        randomAnimeView.isHidden = false
        searchResultsTableView.isHidden = true
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let searchText = searchBar.text else {
            return
        }
        if searchText.isEmpty {
            return
        }
        if lastSearchText == searchText {
            return
        }
        deleteSearchResultsData()
        searchResultsTableView.showAnimatedSkeleton()
        search(searchText: searchText, after: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textEditingTimer?.invalidate()
        if searchText.isEmpty {
            deleteSearchResultsData()
            return
        }
        textEditingTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
            self.deleteSearchResultsData()
            self.searchResultsTableView.showAnimatedSkeleton()
            self.search(searchText: searchText, after: 0)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        randomAnimeView.isHidden = true
        searchResultsTableView.isHidden = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchText = searchBar.text else {
            return true
        }
        if searchText.isEmpty {
            randomAnimeView.isHidden = false
            searchResultsTableView.isHidden = true
            searchBar.setShowsCancelButton(false, animated: true)
        } else {
//            cancel button becomes disabled when search bar isn't first responder, force it back enabled
            DispatchQueue.main.async {
                if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                    cancelButton.isEnabled = true
                }
            }
        }
        return true
    }
    
    private func search(searchText: String, after: Int) {
        lastSearchText = searchText
        self.presenter.getSearchResults(searchText: searchText, after: 0)
    }
}

// MARK: - AnimeTableViewDelegate
extension SearchViewController: SearchResultsTableViewDelegate {
    func cellClicked(at indexPath: IndexPath) {
        presenter.cellClicked(at: indexPath)
    }
    
    func getImage(forIndexPath indexPath: IndexPath) {
        presenter.getImage(forIndexPath: indexPath)
    }
    
    func getData(after value: Int) {
        presenter.getSearchResults(searchText: searchBar.text ?? "", after: value)
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: RandomAnimeViewDelegate {
    func viewTapped() {
        presenter.randomAnimeViewTapped()
    }
    
    func getRandomAnimeData() {
        presenter.getRandomAnimeData()
    }
}

// MARK: - SearchViewProtocol
extension SearchViewController: SearchViewProtocol {
    func showErrorAlert(with title: String, message: String) {
        Alert.showErrorAlert(on: self, with: title, message: message)
    }
    
    func updateSearchResultsTableView(data: [SearchResultsModel]) {
        searchResultsTableView.update(data)
    }
    
    func addMoreSearchResultsTableView(data: [SearchResultsModel], needLoadMoreData: Bool) {
        searchResultsTableView.addMore(data, needLoadMoreData: needLoadMoreData)
    }
    
    func updateSearchResultsTableView(image: UIImage?, for indexPath: IndexPath) {
        searchResultsTableView.update(image, for: indexPath)
    }
    
    func showSearchResultsErrorFooterView(with message: String) {
        searchResultsTableView.showErrorFooterView(with: message)
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
