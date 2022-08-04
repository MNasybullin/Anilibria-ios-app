//
//  TabBarView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.07.2022.
//

import Foundation
import UIKit

protocol TabBarViewProtocol: AnyObject {
    var presenter: TabBarPresenterProtocol! { get set }
}

final class TabBarViewController: UITabBarController, TabBarViewProtocol {
    var presenter: TabBarPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #warning("Test")
        let network = QueryService()
        Task {
            do {
                try await network.logout()
            } catch {
                let nsError = error as NSError
                if nsError.code == -1200 {
                    print("Use VPN")
                } else {
                    print(error)
                }
            }
        }
    }
    
}
