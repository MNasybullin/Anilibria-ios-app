//
//  UpdatesViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.01.2023.
//

import Foundation
import UIKit

protocol UpdatesViewProtocol: AnyObject {
    var presenter: UpdatesPresenterProtocol! { get set }
}

final class UpdatesViewController: UIViewController, UpdatesViewProtocol {
    var presenter: UpdatesPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
