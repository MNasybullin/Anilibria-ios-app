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
}

final class SearchViewController: UIViewController, SearchViewProtocol {
    var presenter: SearchPresenterProtocol!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureNavigationItem()
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: ScheduleRouter.start(withNavigationController: UINavigationController()).entry)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.definesPresentationContext = true
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
}

// MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate {
    
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
