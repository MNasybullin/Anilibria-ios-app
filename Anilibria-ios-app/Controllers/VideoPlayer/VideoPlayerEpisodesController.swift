//
//  VideoPlayerEpisodesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.12.2023.
//

import UIKit

final class VideoPlayerEpisodesController: UIViewController, HasCustomView {
    typealias CustomView = EpisodesView
    
    let contentController: EpisodesContentController
    let currentPlaylistNumber: Int
    let completionBlock: (Int) -> Void
    
    // MARK: LifeCycle
    init(data: AnimeItem, currentPlaylistNumber: Int, completionBlock: @escaping (Int) -> Void) {
        contentController = EpisodesContentController(data: data)
        self.currentPlaylistNumber = currentPlaylistNumber
        self.completionBlock = completionBlock
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
        
        contentController.delegate = self
        setupNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToCurrentPlaylist()
    }
}

// MARK: - Private methods

private extension VideoPlayerEpisodesController {
    func setupNavigationItem() {
        navigationItem.title = Strings.EpisodesModule.episodesTitle
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTapped))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    func scrollToCurrentPlaylist() {
        let indexPath = IndexPath(row: currentPlaylistNumber, section: 0)
        customView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}

// MARK: - EpisodesContentControllerDelegate

extension VideoPlayerEpisodesController: EpisodesContentControllerDelegate {
    func didSelectItem(animeItem: AnimeItem, currentPlaylist: Int) {
        completionBlock(currentPlaylist)
        dismiss(animated: true)
    }
}
