//
//  AnimeNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

protocol AnimeFlow: AnyObject {
    /// use weak !
    var navigator: AnimeNavigator? { get set }
}

final class AnimeNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - BasicNavigator

extension AnimeNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return navigationController
    }
}

// MARK: - Navigator

extension AnimeNavigator: Navigator {
    enum Destinition {
        case series(AnimeItem)
    }
    
    func show(_ destination: Destinition) {
        let viewController = makeViewController(destination)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeViewController(_ destination: Destinition) -> UIViewController {
        let viewController: UIViewController & AnimeFlow
        switch destination {
            case .series(let data):
                viewController = SeriesController(data: data)
                viewController.title = data.ruName
        }
        viewController.navigator = self
        return viewController
    }
}
