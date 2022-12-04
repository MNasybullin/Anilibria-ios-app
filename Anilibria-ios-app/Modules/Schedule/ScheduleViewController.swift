//
//  ScheduleViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import Foundation
import UIKit

protocol ScheduleViewProtocol: AnyObject {
    var presenter: SchedulePresenterProtocol! { get set }
}

final class ScheduleViewController: UIViewController, ScheduleViewProtocol {
    var presenter: SchedulePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
