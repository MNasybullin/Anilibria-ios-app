//
//  HomeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit

final class HomeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = HomeView
    
    weak var navigator: HomeNavigator?
    
    var contentController = HomeContentController()
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.configureCollectionViewDelegate(contentController)
        
        configureNavigationItem()
        configureNavigationBarAppearance()
        
        configureContentController()
    }
}

// MARK: - Private methods

private extension HomeController {
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func configureNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    func configureContentController() {
        let cellProvider = contentController.configureCellProvider()
        let dataSource = customView.configureDataSource(cellProvider: cellProvider)
        contentController.configureDataSource(dataSource)
    }
}

// MARK: - HasScrollableView

extension HomeController: HasScrollableView {
    func scrollToTop() {
        customView.scrollToTop()
    }
}
