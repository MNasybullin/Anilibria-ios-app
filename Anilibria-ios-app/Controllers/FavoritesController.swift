//
//  FavoritesController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.01.2024.
//

import UIKit

final class FavoritesController: UIViewController, FavoritesFlow, HasCustomView {
    typealias CustomView = FavoritesView
    var navigator: FavoritesNavigator?
    
    override func loadView() {
        view = FavoritesView()
    }
    
}
