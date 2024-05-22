//
//  AnimeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit
import OSLog

final class AnimeController: UIViewController, AnimeFlow, HasCustomView {
    typealias CustomView = AnimeView
    typealias Localization = Strings.AnimeModule
    weak var navigator: AnimeNavigator?
    
    private var franchiseController: FranchiseController?
    private let model: AnimeModel
    private (set) var interactiveTransitionController: PopSwipeInteractiveTransitionController?
    private let hasInteractiveTransitionController: Bool
    
    // MARK: LifeCycle
    init(rawData: TitleAPIModel, image: UIImage?, hasInteractiveTransitionController: Bool = false) {
        self.hasInteractiveTransitionController = hasInteractiveTransitionController
        self.model = AnimeModel(rawData: rawData, image: image)
        super.init(nibName: nil, bundle: nil)
        
        model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let item = model.getAnimeItem()
        let episodeNumber = model.getContinueWatchingEpisodeNumber()
        view = AnimeView(delegate: self, item: item, continueWatchingEpisodeNumber: episodeNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureNavigationItem()
        setupInteractiveTransitionController()
        setupFranchiseController()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        checkFavoriteStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isPopedAnimeController() {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

}

// MARK: - Private methods

private extension AnimeController {
    private func configureNavBar() {
        fd_prefersNavigationBarHidden = true
    }
    
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    /// Only For viewWillDisappear !
    func isPopedAnimeController() -> Bool {
        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 1 {
            let previousViewController = viewControllers[viewControllers.count - 1]
            
            if previousViewController is AnimeController {
                return true
            } else {
                return false
            }
        } else {
            // Нет предыдущего контроллера или не удается получить информацию
            return false
        }
    }
    
    func checkFavoriteStatus() {
        guard model.isAuthorized() == true else {
            return
        }
        Task(priority: .userInitiated) {
            do {
                customView.favoriteButtonIsSelected = true
                customView.favoriteButtonShowActivityIndicator = true
                customView.favoriteButtonIsSelected = try await model.isFavorite()
                customView.favoriteButtonShowActivityIndicator = false
            } catch {
                customView.favoriteButtonIsSelected = false
                customView.favoriteButtonShowActivityIndicator = false
                
                let logger = Logger(subsystem: .anime, category: .empty)
                logger.error("\(Logger.logInfo(error: error))")
                
                let data = NotificationBannerView.BannerData(title: Strings.AnimeModule.Error.checkFavorite,
                                                             detail: error.localizedDescription,
                                                             type: .error)
                NotificationBannerView(data: data).show(onView: customView)
            }
        }
    }
    
    func setupInteractiveTransitionController() {
        if hasInteractiveTransitionController {
            interactiveTransitionController = PopSwipeInteractiveTransitionController(viewController: self)
        }
    }
    
    func setupFranchiseController() {
        let franchises = model.getFranchises()
        guard franchises.isEmpty == false else { return }
        franchiseController = FranchiseController(franchisesData: franchises)
        franchiseController!.delegate = self
        franchiseController!.animeView = customView
        
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
    
    func navBarCommentsButtonTapped() {
        let item = model.getAnimeItem()
        navigator?.show(.vkComments(data: item))
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
        if let currentPlaylist = model.getContinueWatchingCurrentPlaylist() {
            navigator?.show(.videoPlayer(data: data, currentPlaylist: currentPlaylist))
        } else {
            navigator?.show(.episodes(data: data))
        }
    }
    
    func downloadButtonClicked() {
        print(#function)
    }
}

// MARK: - FavoriteAndShareButtonsViewDelegate

extension AnimeController: FavoriteAndShareButtonsViewDelegate {
    func favoriteButtonClicked(button: UIButton) {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        
        let buttonIsSelected = !button.isSelected
        customView.favoriteButtonShowActivityIndicator = true
        
        Task(priority: .userInitiated) {
            await handleFavoriteAction(buttonIsSelected: buttonIsSelected)
        }
    }

    private func handleFavoriteAction(buttonIsSelected: Bool) async {
        let status: Bool
        if buttonIsSelected {
            status = await addFavorite()
        } else {
            status = await delFavorite()
        }
        updateUIAfterFavoriteAction(isSelected: buttonIsSelected, actionSucceeded: status)
    }

    private func updateUIAfterFavoriteAction(isSelected: Bool, actionSucceeded: Bool) {
        customView.favoriteButtonShowActivityIndicator = false
        
        if actionSucceeded {
            customView.favoriteButtonIsSelected = isSelected
            if isSelected {
                customView.showFavoriteButtonEffect()
            }
        } else {
            customView.favoriteButtonIsSelected = !isSelected
        }
    }
    
    private func addFavorite() async -> Bool {
        do {
            try await model.addFavorite()
            return true
        } catch {
            errorHandlerForFavoriteAction(error: error, title: Localization.Error.addFavorite)
            return false
        }
    }
    
    private func delFavorite() async -> Bool {
        do {
            try await model.delFavorite()
            return true
        } catch {
            errorHandlerForFavoriteAction(error: error, title: Localization.Error.delFavorite)
            return false
        }
    }
    
    private func errorHandlerForFavoriteAction(error: Error, title: String) {
        let logger = Logger(subsystem: .anime, category: .empty)
        logger.error("\(Logger.logInfo(error: error))")
        
        let bannerData = NotificationBannerView.BannerData(
            title: title,
            detail: error.localizedDescription,
            type: .error)
        NotificationBannerView(data: bannerData)
            .show()
    }
    
    func shareButtonClicked() {
        let textToShare = model.getSharedText()
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - FranchiseControllerDelegate

extension AnimeController: FranchiseControllerDelegate {
    func didSelectItem(data: TitleAPIModel, image: UIImage?) {
        let currentAnime = model.getAnimeItem()
        
        if data.id == currentAnime.id {
            customView.scrollToTop()
        } else {
            navigator?.show(.anime(data: data, image: image))
        }
    }
}

// MARK: - HasPosterCellAnimatedTransitioning

extension AnimeController: HasPosterCellAnimatedTransitioning {
    var selectedCell: PosterCollectionViewCell? {
        franchiseController?.selectedCell
    }
    
    var selectedCellImageViewSnapshot: UIView? {
        franchiseController?.selectedCellImageViewSnapshot
    }
}
