//
//  SeriesViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06/04/2023.
//

import UIKit

protocol SeriesViewProtocol: AnyObject {
	var presenter: SeriesPresenterProtocol! { get set }
}

final class SeriesViewController: UIViewController, SeriesViewProtocol {
	var presenter: SeriesPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
