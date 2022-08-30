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
    private var contentView = UIView()
    private var stackView = UIStackView()
    private var todayCarouselView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Asset.Colors.background.color
        self.navigationItem.title = "AniLibria"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        configureContentView()
        configureStackView()
        
    }
    
    // MARK: - ScrollView
    func configureScrollView() {
        view.addSubview(scrollView)
        setScrollViewConstraints()
    }
    
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - ContentView
    func configureContentView() {
        view.addSubview(contentView)
        setContentViewConstraints()
    }
    
    func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - StackView
    func configureStackView() {
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        
        configureTodayCarouselView()
        
        setStackViewConstraints()
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let stackViewHeight = stackView.arrangedSubviews.reduce(0) {$0 + $1.frame.height + stackView.spacing}
        stackView.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
    }
    
    // MARK: - ToDayCarouselView
    func configureTodayCarouselView() {
        todayCarouselView = CarouselView(title: "Title", buttonTitle: "All", type: .largeVerticalPoster)
        stackView.addArrangedSubview(todayCarouselView)
        setTodayCarouselViewConstraints()
    }
    
    func setTodayCarouselViewConstraints() {

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
