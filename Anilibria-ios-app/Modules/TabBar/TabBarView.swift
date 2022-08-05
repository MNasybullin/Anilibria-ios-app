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
//        Task {
//            do {
//                try await network.logout()
//            }
//        }
        Task {
            do {
                let data = try await QueryService.shared.login(mail: "anilibria_test@mail.ru", password: "TestPasswordTest")
                let profile = try await QueryService.shared.profileInfo()
                print(data)
                print(profile)
            } catch {
                let nsError = error as NSError
                if nsError.code == -1200 {
                    print("Use VPN")
                } else {
                    print(error)
                }
            }
        }
//        Task {
//            do {
////                try await QueryService.shared.addFavorite(from: 1)
//                try await QueryService.shared.delFavorite(from: 1)
//            } catch {
//                print("addFavorite", error)
//            }
//        }
//        Task {
//            do {
//                try await QueryService.shared.logout()
//            } catch {
//                print("logout", error)
//            }
//        }
    }
    
}
