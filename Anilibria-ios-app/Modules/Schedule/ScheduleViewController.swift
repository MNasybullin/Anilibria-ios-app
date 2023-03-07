//
//  ScheduleViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation
import UIKit
import Combine

protocol ScheduleViewProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
    
    func showErrorAlert(with title: String, message: String)
    func update(data: [PostersListViewModel])
    func update(image: UIImage, for indexPath: IndexPath)
}

final class ScheduleViewController: UIViewController, ScheduleViewProtocol {
    var presenter: SchedulePresenterProtocol!
    
    private var postersListView: PostersListView!
    
    private var cancellable: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePostersListView()
        subscribeToNetworkMonitor()
    }
    
    private func subscribeToNetworkMonitor() {
        cancellable = NetworkMonitor.shared.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                if isConnected == true {
                    self.getData()
                }
            }
    }
    
    // MARK: - PostersListView
    
    private func configurePostersListView() {
        postersListView = PostersListView()
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
    
    // MARK: - ScheduleViewProtocol Functions
    
    func showErrorAlert(with title: String, message: String) {
        Alert.showErrorAlert(on: self, with: title, message: message)
    }
    
    func update(data: [PostersListViewModel]) {
        postersListView.updateData(data)
    }
    
    func update(image: UIImage, for indexPath: IndexPath) {
        postersListView.updateImage(image, for: indexPath)
    }
}

// MARK: - PostersListViewProtocol

extension ScheduleViewController: PostersListViewProtocol {
    func getData() {
        presenter.getScheduleData()
    }
    
    func getImage(for indexPath: IndexPath) {
        presenter.getImage(for: indexPath)
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct ScheduleViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ScheduleRouter.start(withNavigationController: UINavigationController()).entry
        }
    }
}

#endif
