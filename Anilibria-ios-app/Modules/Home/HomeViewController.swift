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
    
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    var stackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.spacing = 10
//        return stack
//    }()
    
    var todayCarouselView: CarouselView = {
        let carouselView = CarouselView(title: "Title", buttonTitle: "All", type: .standartVerticalPoster)
        return carouselView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.background.color
        navigationItem.title = "AniLibria"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(todayCarouselView)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
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
