//
//  HomeNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol HomeFlow: AnyObject {
    /// use weak !
    var navigator: HomeNavigator? { get set }
}

final class HomeNavigator: NSObject {
    private let navigationController: UINavigationController
    private var subNavigators: [BasicNavigator] = []
    
    override init() {
        let rootViewController = HomeController()
        
        navigationController = HomeNavigator.createNavigationController(for: rootViewController)
        super.init()
        navigationController.delegate = self
        
        rootViewController.navigator = self
    }
        
    private static func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let title = Strings.TabBarControllers.Home.title
        let image = UIImage(systemName: Strings.TabBarControllers.Home.image)
        
        rootViewController.tabBarItem = UITabBarItem(title: title, 
                                                image: image,
                                                tag: TabBarItemTags.home.rawValue)
        rootViewController.navigationItem.title = Strings.ScreenTitles.home
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Configure navigationBar
        navigationController.navigationBar.standardAppearance.configureWithOpaqueBackground()
        navigationController.navigationBar.standardAppearance.shadowColor = .clear
        navigationController.navigationBar.tintColor = .systemRed
        
        // Common/UINavigationControllerExtension file
        navigationController.interactivePopGestureRecognizer?.delegate = navigationController
        
        return navigationController
    }
}

// MARK: - BasicNavigator

extension HomeNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension HomeNavigator: Navigator {
    enum Destination {
        case schedule
        case anime(data: TitleAPIModel, image: UIImage?, hasInteractiveTransitionController: Bool = true)
        case episodes(data: TitleAPIModel)
        case youTube(data: [HomePosterItem], rawData: [YouTubeAPIModel])
        case videoPlayer(animeId: Int, numberOfEpisode: Float)
    }
    
    func show(_ destination: Destination) {
        switch destination {
            case .schedule:
                let scheduleController = ScheduleController()
                scheduleController.title = Strings.ScreenTitles.schedule
                scheduleController.navigator = self
                navigationController.pushViewController(scheduleController, animated: true)
            case .anime(let rawData, let image, let hasInteractiveTransitionController):
                let animeController = configureAnimeController(rawData: rawData,
                                                        image: image,
                                                        hasInteractiveTransitionController: hasInteractiveTransitionController)
                navigationController.pushViewController(animeController, animated: true)
            case .episodes(let rawData):
                let animeController = configureAnimeController(rawData: rawData,
                                                        image: nil,
                                                        hasInteractiveTransitionController: false)
                let navigator = animeController.navigator
                navigator?.show(.episodes(data: AnimeItem(fromTitleApiModel: rawData, image: nil)))
            case .youTube(let data, let rawData):
                let youTubeController = YouTubeController(data: data, rawData: rawData)
                youTubeController.title = Strings.ScreenTitles.youTube
                youTubeController.navigator = self
                navigationController.pushViewController(youTubeController, animated: true)
            case .videoPlayer(let animeId, let numberOfEpisode):
                let playerNavigator = VideoPlayerNavigator.shared
                playerNavigator.show(.playerNoData(animeId: animeId, numberOfEpisode: numberOfEpisode, presentatingController: navigationController))
        }
    }
}

// MARK: - Private Methods

private extension HomeNavigator {
    func configureAnimeController(rawData: TitleAPIModel, image: UIImage?, hasInteractiveTransitionController: Bool) -> AnimeController {
        let animeController = AnimeController(rawData: rawData, image: image, hasInteractiveTransitionController: hasInteractiveTransitionController)
        let animeNavigator = AnimeNavigator(navigationController: navigationController)
        subNavigators.append(animeNavigator)
        animeController.navigator = animeNavigator
        return animeController
    }
}

// MARK: - UINavigationControllerDelegate

extension HomeNavigator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AnimeAnimator(type: operation, from: fromVC, to: toVC)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animeAnimator = animationController as? AnimeAnimator,
              let interactiveTransitionController = animeAnimator.interactionController,
              interactiveTransitionController.interactionInProgress else {
            return nil
        }
        return interactiveTransitionController
    }
}
