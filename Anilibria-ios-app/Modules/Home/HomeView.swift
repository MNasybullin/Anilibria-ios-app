//
//  HomeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
}

class HomeView: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    
}
