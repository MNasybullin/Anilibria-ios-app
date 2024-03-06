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
    private let errorProcessing = ErrorProcessing.shared
    
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
        view = AnimeView(delegate: self, item: item)
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
                logger.error("\(Logger.logInfo()) \(error)")
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
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
        
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
            
            let bannerData = NotificationBannerView.BannerData(
                title: Localization.Error.addFavorite,
                detail: errorProcessing.getMessageFrom(error: error),
                type: .error)
            NotificationBannerView(data: bannerData)
                .show()
        }
    }
    
    private func delFavorite() async {
        do {
            try await model.delFavorite()
        } catch {
            customView.favoriteButtonIsSelected = true
            
            let bannerData = NotificationBannerView.BannerData(
                title: Localization.Error.delFavorite,
                detail: errorProcessing.getMessageFrom(error: error),
                type: .error)
            NotificationBannerView(data: bannerData)
                .show()
        }
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
    func showAnime(data: TitleAPIModel, image: UIImage?) {
        navigator?.show(.anime(data: data, image: image))
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
