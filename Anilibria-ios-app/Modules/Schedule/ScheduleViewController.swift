//
//  ScheduleViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation
import UIKit

protocol ScheduleViewProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
    
    func showErrorAlert(with title: String, message: String)
    func update(data: [PostersListViewModel])
    func update(itemData data: PostersListModel, for indexPath: IndexPath)
}

final class ScheduleViewController: UIViewController, ScheduleViewProtocol {
    var presenter: SchedulePresenterProtocol!
    
    private var postersListView: PostersListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePostersListView()
    }
    
    // MARK: - PostersListView
    
    private func configurePostersListView() {
        postersListView = PostersListView()
        postersListView.delegate = self
        presenter.getScheduleData()
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
    
    // MARK: - ScheduleViewProtocol Functions
    
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

extension ScheduleViewController: PostersListViewProtocol {
    func getImage(for indexPath: IndexPath) {
        presenter.getImage(for: indexPath)
    }
}
