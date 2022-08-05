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
                async let data = try QueryService.shared.login(mail: "anilibria_test@mail.ru", password: "TestPasswordTest")
                async let profile = try QueryService.shared.profileInfo()
                let image = try await QueryService.shared.getImage(from: profile.data!.avatar)
                await print(try data)
                await print(try profile)
                print(image)
//                print(await data)
//                print(await profile)
//                print(await image)
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
//                try await QueryService.shared.addFavorite(from: 1)
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
