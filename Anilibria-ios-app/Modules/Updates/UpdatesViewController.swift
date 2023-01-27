//
//  UpdatesViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation
import UIKit

protocol UpdatesViewProtocol: AnyObject {
    var presenter: UpdatesPresenterProtocol! { get set }
    
    func showErrorAlert(with title: String, message: String)
    func update(data: [PostersListViewModel])
    func update(itemData data: PostersListModel, for indexPath: IndexPath)
}

final class UpdatesViewController: UIViewController, UpdatesViewProtocol {
    var presenter: UpdatesPresenterProtocol!
    
    var postersListView: PostersListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePostersListView()
    }
    
    // MARK: - PostersListView
    
    private func configurePostersListView() {
        postersListView = PostersListView()
        postersListView.delegate = self
        presenter.getUpdatesData()
        view.addSubview(postersListView)
        setPostersListViewConstraints()
    }
    
    private func setPostersListViewConstraints() {
        postersListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postersListView.topAnchor.constraint(equalTo: view.topAnchor),
            postersListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postersListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postersListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UpdatesViewProtocol Functions
    
    func showErrorAlert(with title: String, message: String) {
        Alert.showErrorAlert(on: self, with: title, message: message)
    }
    
    func update(data: [PostersListViewModel]) {
        postersListView.updateData(data)
    }
    
    func update(itemData data: PostersListModel, for indexPath: IndexPath) {
        postersListView.updateItemData(data, for: indexPath)
    }
}

// MARK: - PostersListViewProtocol

extension UpdatesViewController: PostersListViewProtocol {
    func getImage(for indexPath: IndexPath) {
        presenter.getImage(for: indexPath)
    }
}
