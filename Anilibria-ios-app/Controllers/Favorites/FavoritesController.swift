//
//  FavoritesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.01.2024.
//

import UIKit
import Combine

final class FavoritesController: UIViewController, FavoritesFlow, HasCustomView {
    typealias CustomView = FavoritesView
    
    weak var navigator: FavoritesNavigator?
    private var contentController: FavoritesContentController!
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func loadView() {
        view = FavoritesView(navigationItem: navigationItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentController = FavoritesContentController(customView: customView, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notificationCenterSubscription()
        contentController.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        subscriptions.removeAll()
    }
}

// MARK: - Private methods

private extension FavoritesController {
    func notificationCenterSubscription() {
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.contentController.loadData()
            }
            .store(in: &subscriptions)
    }
}

// MARK: - FavoritesContentControllerDelegate

extension FavoritesController: FavoritesContentControllerDelegate {
    func didSelectItem(data: TitleAPIModel, image: UIImage?) {
        navigator?.show(.anime(data: data, image: image))
    }
}
