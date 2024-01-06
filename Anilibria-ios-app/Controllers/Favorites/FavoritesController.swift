//
//  FavoritesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.01.2024.
//

import UIKit

final class FavoritesController: UIViewController, FavoritesFlow, HasCustomView {
    typealias CustomView = FavoritesView
    
    weak var navigator: FavoritesNavigator?
    private var contentController: FavoritesContentController!
    
    override func loadView() {
        view = FavoritesView(navigationItem: navigationItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentController = FavoritesContentController(customView: customView, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentController.loadData()
    }
}

// MARK: - FavoritesContentControllerDelegate

extension FavoritesController: FavoritesContentControllerDelegate {
    func didSelectItem(data: TitleAPIModel, image: UIImage?) {
        navigator?.show(.anime(data: data, image: image))
    }
}
