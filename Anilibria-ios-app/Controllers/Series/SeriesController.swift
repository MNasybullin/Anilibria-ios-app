//
//  SeriesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.10.2023.
//

import UIKit

final class SeriesController: UIViewController, AnimeFlow, HasCustomView {
    typealias CustomView = SeriesView
    weak var navigator: AnimeNavigator?
    
    let contentController: SeriesContentController
    
    // MARK: LifeCycle
    init(data: AnimeItem) {
        contentController = SeriesContentController(data: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SeriesView(delegate: contentController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        contentController.viewIsAppearing()
    }
}

// MARK: - Private methods

private extension SeriesController {
    func setupContentController() {
        contentController.delegate = self
        contentController.customView = customView
    }
}

// MARK: - SeriesContentControllerDelegate

extension SeriesController: SeriesContentControllerDelegate {
    func didSelectItem(animeItem: AnimeItem, currentPlaylist: Int) {
        navigator?.show(.videoPlayer(data: animeItem, currentPlaylist: currentPlaylist))
    }
}
