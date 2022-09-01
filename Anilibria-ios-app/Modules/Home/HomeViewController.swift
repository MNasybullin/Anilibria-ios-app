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
    
    private var scrollView = UIScrollView()
    private var scrollStackViewContainer = UIStackView()
    private var todayCarouselView: CarouselView!
    private var updatesCarouselView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Asset.Colors.background.color
        self.navigationItem.title = "AniLibria"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        configureScrollView()
        configureScrollStackViewContainer()
        configureTodayCarouselView()
        configureUpdatesCarouselView()
        
    }
    
    // MARK: - scrollView
    func configureScrollView() {
        view.addSubview(scrollView)
        setScrollViewConstraints()
    }
    
    func setScrollViewConstraints() {
        let margins = view.layoutMarginsGuide
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
        
    // MARK: - scrollStackViewContainer
    func configureScrollStackViewContainer() {
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.axis = .vertical
        scrollStackViewContainer.spacing = 10
        setScrollStackViewContainerConstraints()
    }
    
    func setScrollStackViewContainerConstraints() {
        scrollStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    // MARK: - toDayCarouselView
    func configureTodayCarouselView() {
        todayCarouselView = CarouselView(title: "Сегодня", buttonTitle: "Все дни", type: .largeVerticalPoster)
        scrollStackViewContainer.addArrangedSubview(todayCarouselView)
        setTodayCarouselViewConstraints()
    }
    
    func setTodayCarouselViewConstraints() {
        todayCarouselView.heightAnchor.constraint(equalToConstant: todayCarouselView.frame.height).isActive = true
    }
    
    // MARK: - updatesCarouselView
    func configureUpdatesCarouselView() {
        updatesCarouselView = CarouselView(title: "Обновления", buttonTitle: "Все", type: .standartVerticalPoster)
        scrollStackViewContainer.addArrangedSubview(updatesCarouselView)
        setUpdatesCarouselViewConstraints()
    }
    
    func setUpdatesCarouselViewConstraints() {
        updatesCarouselView.heightAnchor.constraint(equalToConstant: updatesCarouselView.frame.height).isActive = true
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
