//
//  YouTubeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.12.2023.
//

import UIKit

final class YouTubeController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = YouTubeView
    weak var navigator: HomeNavigator?
    
    private let contentController: YouTubeContentController
    
    // MARK: LifeCycle
    init(data: [HomePosterItem], rawData: [YouTubeAPIModel]) {
        contentController = YouTubeContentController(data: data, rawData: rawData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let youTubeView = YouTubeView()
        youTubeView.collectionViewDataSource = contentController
        youTubeView.collectionViewDataSourcePrefetching = contentController
        youTubeView.collectionViewDelegate = contentController
        view = youTubeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
    
    private func setupContentController() {
        contentController.delegate = self
        contentController.collectionView = customView.collectionView
        
        customView.collectionViewDataSource = contentController
        customView.collectionViewDataSourcePrefetching = contentController
        customView.collectionViewDelegate = contentController
    }
}

// MARK: - YouTubeContentControllerDelegate

extension YouTubeController: YouTubeContentControllerDelegate {
    func insertItems(at indexPaths: [IndexPath]) {
        customView.insertRows(at: indexPaths)
    }
    
    func didSelectItem(rawdata: YouTubeAPIModel) {
        let urlString = NetworkConstants.youTubeWatchURL + rawdata.youtubeId
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
