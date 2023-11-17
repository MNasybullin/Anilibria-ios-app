//
//  SearchController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

final class SearchController: UIViewController, SearchFlow, HasCustomView {
    typealias CustomView = SearchView
    typealias Status = SearchView.Status
    weak var navigator: SearchNavigator?
    
    private let randomAnimeController = RandomAnimeController()
    private let resultsController = SearchResultsController()
    
    private var status: Status = .normal {
        didSet {
            customView.updateView(status: status)
        }
    }
    
    private var textEditingTimer: Timer?
    private var lastSearchText: String?
    
    override func loadView() {
        addChild(randomAnimeController)
        addChild(resultsController)
        
        view = SearchView(
            delegate: self,
            randomAnimeView: randomAnimeController.view,
            resultsView: resultsController.view,
            navigationItem: navigationItem)
        
        randomAnimeController.didMove(toParent: self)
        resultsController.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomAnimeController.delegate = self
        resultsController.delegate = self
    }
    
}

// MARK: - Private methods

private extension SearchController {
    func search(searchText: String) {
        lastSearchText = searchText
        resultsController.searchTitle(searchText: searchText)
        status = .result
    }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        resultsController.cancelTasks()
        
        status = .normal
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
        resultsController.cancelTasks()
        search(searchText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textEditingTimer?.invalidate()
        if searchText.isEmpty {
            resultsController.cancelTasks()
            status = .history
            return
        }
        textEditingTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
            self.resultsController.cancelTasks()
            self.search(searchText: searchText)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        if let searchText = searchBar.text, searchText.isEmpty == false {
            status = .result
        } else {
            status = .history
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchText = searchBar.text else {
            return true
        }
        if searchText.isEmpty {
            status = .normal
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
}

// MARK: - RandomAnimeControllerDelegate

extension SearchController: RandomAnimeControllerDelegate {
    func randomAnimeViewDidTapped(data: TitleAPIModel) {
        navigator?.show(.anime(data: data))
    }
}

// MARK: - SearchResultsControllerDelegate

extension SearchController: SearchResultsControllerDelegate {
    func didSelectedItem(item: TitleAPIModel) {
        customView.hideKeyboard()
        navigator?.show(.anime(data: item))
    }
}

// MARK: -

extension SearchController: HasSearchBar {
    func searchBarBecomeFirstResponder() {
        customView.searchBarBecomeFirstResponder()
    }
}
