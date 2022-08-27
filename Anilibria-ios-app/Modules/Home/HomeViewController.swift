//
//  HomeViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
}

final class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    
    lazy var segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: Strings.HomeModule.SegmentedControl.feed,
                                       at: 0,
                                       animated: true)
        segmentedControl.insertSegment(withTitle: Strings.HomeModule.SegmentedControl.schedule,
                                       at: 1,
                                       animated: true)
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        return segmentedControl
    }()
    
    lazy var carouselView: CarouselView = {
        let carouselView = CarouselView()
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(carouselView)
        return carouselView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.background.color
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            carouselView.topAnchor.constraint(equalTo: segmentedControl.layoutMarginsGuide.bottomAnchor, constant: 20),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            carouselView.heightAnchor.constraint(equalToConstant: view.frame.width / 1.3)
        ])
    }
    
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            HomeRouter.start().navigationController
        }
    }
}

#endif
