//
//  VideoPlayerSeriesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.12.2023.
//

import UIKit

final class VideoPlayerSeriesController: UIViewController, HasCustomView {
    typealias CustomView = SeriesView
    
    let contentController: SeriesContentController
    let currentPlaylistNumber: Int
    let completionBlock: (Int) -> Void
    
    // MARK: LifeCycle
    init(data: AnimeItem, currentPlaylistNumber: Int, completionBlock: @escaping (Int) -> Void) {
        contentController = SeriesContentController(data: data)
        self.currentPlaylistNumber = currentPlaylistNumber
        self.completionBlock = completionBlock
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
        
        contentController.delegate = self
        setupNavigationItem()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        configureTableView()
    }
}

// MARK: - Private methods

private extension VideoPlayerSeriesController {
    func setupNavigationItem() {
        navigationItem.title = Strings.SeriesModule.seriesTitle
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonDidTapped))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    func configureTableView() {
        let indexPath = IndexPath(row: currentPlaylistNumber, section: 0)
        customView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}

// MARK: - SeriesContentControllerDelegate

extension VideoPlayerSeriesController: SeriesContentControllerDelegate {
    func didSelectItem(animeItem: AnimeItem, currentPlaylist: Int) {
        completionBlock(currentPlaylist)
        dismiss(animated: true)
    }
}
