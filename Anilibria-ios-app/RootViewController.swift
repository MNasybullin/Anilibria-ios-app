//
//  RootViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.02.2023.
//

import Foundation
import UIKit

final class RootViewController: UIViewController {
    static let shared: RootViewController = RootViewController()
    
    private var tabBar: (UITabBarController & TabBarViewProtocol) = {
        return TabBarRouter.start().entry
    }()
    
    var safeAreaInsetsBottomHeight: CGFloat?
    
    private var networkActivityView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 16)) //
        view.backgroundColor = .red //
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let networkActivityViewHeight: CGFloat = 16
    
    var hideBottomBar: Bool = true {
        didSet {
            if hideBottomBar {
                heightConstraint.constant = 0
            } else {
                heightConstraint.constant = (safeAreaInsetsBottomHeight ?? 0) + networkActivityViewHeight
            }
            updateView()
        }
    }
    
    private var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        networkActivityViewConfigure()
        heightConstraintConfigure()
        tabBarConfigure()
    }
    
    private func networkActivityViewConfigure() {
        view.addSubview(networkActivityView)
        NSLayoutConstraint.activate([
            networkActivityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            networkActivityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            networkActivityView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func heightConstraintConfigure() {
        heightConstraint = networkActivityView.heightAnchor.constraint(equalToConstant: (safeAreaInsetsBottomHeight ?? 0) + networkActivityViewHeight)
        heightConstraint.isActive = true
        if hideBottomBar {
            heightConstraint.constant = 0
        }
    }
    
    private func tabBarConfigure() {
        addChild(tabBar)
        view.addSubview(tabBar.view)
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.view.topAnchor.constraint(equalTo: view.topAnchor),
            tabBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.view.bottomAnchor.constraint(equalTo: networkActivityView.topAnchor)
        ])
        tabBar.didMove(toParent: self)
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// testing view

//  let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(anim), userInfo: nil, repeats: true)
//  timer.fire()
//
//@objc func anim() {
//    DispatchQueue.main.async {
//        if RootViewController.shared.hideBottomBar == true {
//            RootViewController.shared.hideBottomBar = false
//        } else {
//            RootViewController.shared.hideBottomBar = true
//        }
//    }
//}
