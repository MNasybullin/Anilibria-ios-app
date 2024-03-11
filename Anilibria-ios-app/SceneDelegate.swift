//
//  SceneDelegate.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 11.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let networkMonitor = NetworkMonitor.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainNavigator.shared.rootViewController
        window?.makeKeyAndVisible()
        
        applyAppearance()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        networkMonitor.startMonitoring()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        networkMonitor.stopMonitoring()
        
        CoreDataService.shared.saveContext()
    }

}

extension SceneDelegate {
    func applyAppearance() {
        let style = UserDefaults.standard.appearance
        window?.overrideUserInterfaceStyle = style
    }
}
