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
    
    private var franchiseController: FranchiseController?
    private let model: AnimeModel
    
    // MARK: LifeCycle
    init(rawData: TitleAPIModel, image: UIImage?) {
        self.model = AnimeModel(rawData: rawData, image: image)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        setupFranchiseController()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        checkFavoriteStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
}

// MARK: - Private methods

private extension AnimeController {
    func checkFavoriteStatus() {
        Task(priority: .userInitiated) {
            do {
                customView.favoriteButtonIsSelected = true
                customView.favoriteButtonShowActivityIndicator = true
                customView.favoriteButtonIsSelected = try await model.isFavorite()
                customView.favoriteButtonShowActivityIndicator = false
            } catch {
                print(error, error.localizedDescription)
                customView.favoriteButtonIsSelected = false
                customView.favoriteButtonShowActivityIndicator = false
            }
        }
    }
    
    func setupFranchiseController() {
        let franchises = model.getFranchises()
        guard franchises.isEmpty == false else { return }
        franchiseController = FranchiseController(franchisesData: franchises)
        franchiseController?.delegate = self
        
        addChild(franchiseController!)
        
        customView.appendFranchiseView(franchiseController!.customView)
        
        franchiseController!.didMove(toParent: self)
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

// MARK: - AnimeEpisodesViewDelegate

extension AnimeController: AnimeEpisodesViewDelegate {
    func episodesViewClicked() {
        let data = model.getAnimeItem()
        navigator?.show(.episodes(data: data))
    }
}

// MARK: - WatchAndDownloadButtonsViewDelegate

extension AnimeController: WatchAndDownloadButtonsViewDelegate {
    func watchButtonClicked() {
        let data = model.getAnimeItem()
        navigator?.show(.episodes(data: data))
    }
    
    func downloadButtonClicked() {
        print(#function)
    }
}

// MARK: - FavoriteAndShareButtonsViewDelegate

extension AnimeController: FavoriteAndShareButtonsViewDelegate {
    func favoriteButtonClicked(button: UIButton) {
        button.isSelected = !button.isSelected
        Task(priority: .utility) {
            if button.isSelected == true {
                await addFavorite()
            } else {
                await delFavorite()
            }
        }
    }
    
    private func addFavorite() async {
        do {
            try await model.addFavorite()
        } catch {
            customView.favoriteButtonIsSelected = false
            // TODO: Если пользователь не авторизован вывести ошибки: "Необходимо авторизоваться"
            print("addFavorite error", error.localizedDescription, error)
        }
    }
    
    private func delFavorite() async {
        do {
            try await model.delFavorite()
        } catch {
            customView.favoriteButtonIsSelected = true
            print("delFavorite error", error.localizedDescription, error)
        }
    }
    
    func shareButtonClicked() {
        let item = model.getAnimeItem()
        let releaseUrl = "/release/" + item.code + ".html"
        let textToShare = """
            \(item.ruName)
            \(NetworkConstants.anilibriaURL + releaseUrl)
            Зеркало: \(NetworkConstants.mirrorAnilibriaURL + releaseUrl)
            """
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        present(activityViewController, animated: true, completion: nil)
    }
}

extension AnimeController: FranchiseControllerDelegate {
    func showAnime(data: TitleAPIModel, image: UIImage?) {
        navigator?.show(.anime(data: data, image: image))
    }
}
