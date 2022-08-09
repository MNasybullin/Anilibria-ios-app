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
        Task {
            do {
                let data = try await QueryService.shared.login(mail: "anilibria_test@mail.ru",
                                                               password: "TestPasswordTest")
                print(data)
            } catch let error as MyNetworkError {
                print(error)
            } catch {
                print(error)
            }
        }
        
//        Task {
//            do {
//                async let profile = try QueryService.shared.profileInfo()
//                let image = try await QueryService.shared.getImage(from: await profile.data!.avatar)
//                print(image)
//            } catch {
//                print("add", error)
//            }
//        }
    }
    
}
