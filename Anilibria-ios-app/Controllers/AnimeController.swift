//
//  AnimeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit

final class AnimeController: UIViewController, AnimeFlow, HasCustomView {
    typealias CustomView = AnimeView
    weak var navigator: AnimeNavigator?
    
    private let model: AnimeModel
    
    init(rawData: TitleAPIModel) {
        self.model = AnimeModel(rawData: rawData)
        super.init(nibName: nil, bundle: nil)
        
        model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let item = model.getAnimeItem()
        view = AnimeView(delegate: self, item: item)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - AnimeViewOutput

extension AnimeController: AnimeViewOutput {
    func navBarBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - AnimeModelOutput

extension AnimeController: AnimeModelOutput {
    func update(image: UIImage) {
        DispatchQueue.main.async {
            self.customView.update(image: image)
        }
    }
}

// MARK: - SeriesViewDelegate

extension AnimeController: SeriesViewDelegate {
    func seriesViewClicked() {
        print(#function)
    }
}

// MARK: - WatchAndDownloadButtonsViewDelegate

extension AnimeController: WatchAndDownloadButtonsViewDelegate {
    func watchButtonClicked() {
        print(#function)
    }
    
    func downloadButtonClicked() {
        print(#function)
    }
}

// MARK: - FavoriteAndShareButtonsViewDelegate

extension AnimeController: FavoriteAndShareButtonsViewDelegate {
    func favoriteButtonClicked() {
        print(#function)
    }
    
    func shareButtonClicked() {
        print(#function)
    }
}
