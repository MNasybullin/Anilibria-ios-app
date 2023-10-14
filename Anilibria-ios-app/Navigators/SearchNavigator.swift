//
//  SearchNavigator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.10.2023.
//

import UIKit

protocol SearchFlow: AnyObject {
    var navigator: SearchNavigator? { get set }
}

final class SearchNavigator {
    
}

// MARK: - BasicNavigator

extension SearchNavigator: BasicNavigator {
    func initialViewController() -> UIViewController {
        return UIViewController()
    }
}

// MARK: - Navigator

extension SearchNavigator: Navigator {
    enum Destinition {
        case anime
        case series
    }
    
    func show(_ destination: Destinition) {
    }
}
