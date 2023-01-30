//
//  UpdatesViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation
import UIKit
/*
protocol UpdatesViewProtocol: AnyObject {
    var presenter: UpdatesPresenterProtocol! { get set }
    
    func showErrorAlert(with title: String, message: String)
    func update(data: [GetScheduleModel])
    func update(imageData: GTImageData, for indexPath: IndexPath)
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
        postersListView = PostersListView(withData: presenter.interactor.getData())
        postersListView.delegate = self
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
    
    func update(data: [GetScheduleModel]) {
        postersListView.updateData(data)
    }
    
    func update(imageData: GTImageData, for indexPath: IndexPath) {
        postersListView.updateImageData(imageData, for: indexPath)
    }
}

// MARK: - PostersListViewProtocol

extension UpdatesViewController: PostersListViewProtocol {
    func getData() {
        presenter.getUpdatesData()
    }
    
    func getImage(for indexPath: IndexPath) {
        presenter.getImage(for: indexPath)
    }
 }
 */
