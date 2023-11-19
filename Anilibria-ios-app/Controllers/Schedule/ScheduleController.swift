//
//  ScheduleController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit

final class ScheduleController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = ScheduleView
    weak var navigator: HomeNavigator?
    
    private lazy var contentController = ScheduleContentController(delegate: self)
    
    override func loadView() {
        view = ScheduleView(collectionViewDelegate: contentController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData()
    }
    
    private func requestData() {
        customView.showSkeletonCollectionView()
        contentController.requestData()
    }
}

// MARK: - ScheduleContentControllerDelegate

extension ScheduleController: ScheduleContentControllerDelegate {
    func didSelectItem(_ rawData: TitleAPIModel) {
        navigator?.show(.anime(data: rawData))
    }
    
    func hideSkeletonCollectionView() {
        customView.hideSkeletonCollectionView()
    }
    
    func reloadData() {
        customView.reloadData()
    }
}
