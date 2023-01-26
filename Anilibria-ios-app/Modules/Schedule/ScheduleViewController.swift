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
}

// MARK: - PostersListViewProtocol

extension ScheduleViewController: PostersListViewProtocol {
    func getImage(forSection section: Int, forIndex index: Int) {
        //
    }
    
}
