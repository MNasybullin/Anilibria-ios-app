//
//  HomeNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol HomeFlow: AnyObject {
    var navigator: HomeNavigator? { get set }
}

final class HomeNavigator {

}

// MARK: - BasicNavigator

extension HomeNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return UIViewController()
    }
}

// MARK: - Navigator

extension HomeNavigator: Navigator {
    enum Destinition {
        case schedule
        case anime
        case series
    }
    
    func show(_ destination: Destinition) {
    }
}
