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
    func update(dataArray: [PostersListViewModel])
    func update(ListData data: PostersListModel, forSection section: Int, forIndex index: Int)
}

final class ScheduleViewController: UIViewController, ScheduleViewProtocol {
    var presenter: SchedulePresenterProtocol!
    
    private var postersListView: PostersListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePostersListView()
    }
    
    // MARK: - PostersListView
    
    func configurePostersListView() {
        postersListView = PostersListView()
        postersListView.delegate = self
        presenter.getScheduleData()
        view.addSubview(postersListView)
        setPostersListViewConstraints()
    }
    
    func setPostersListViewConstraints() {
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
    
    func update(dataArray data: [PostersListViewModel]) {
        postersListView.updateDataArray(data)
    }
    
    func update(ListData data: PostersListModel, forSection section: Int, forIndex index: Int) {
        postersListView.updateListData(data, forSection: section, forIndex: index)
    }
}

// MARK: - PostersListViewProtocol

extension ScheduleViewController: PostersListViewProtocol {
    func getImage(forSection section: Int, forIndex index: Int) {
        presenter.getImage(forSection: section, forIndex: index)
    }
    
}
