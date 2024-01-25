//
//  EpisodesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.10.2023.
//

import UIKit

final class EpisodesController: UIViewController, AnimeFlow, HasCustomView {
    typealias CustomView = EpisodesView
    weak var navigator: AnimeNavigator?
    
    let contentController: EpisodesContentController
    
    // MARK: LifeCycle
    init(data: AnimeItem) {
        contentController = EpisodesContentController(data: data)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = EpisodesView(delegate: contentController)
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

private extension EpisodesController {
    func setupContentController() {
        contentController.delegate = self
        contentController.customView = customView
    }
}

// MARK: - EpisodesContentControllerDelegate

extension EpisodesController: EpisodesContentControllerDelegate {
    func didSelectItem(animeItem: AnimeItem, currentPlaylist: Int) {
        navigator?.show(.videoPlayer(data: animeItem, currentPlaylist: currentPlaylist))
    }
}
