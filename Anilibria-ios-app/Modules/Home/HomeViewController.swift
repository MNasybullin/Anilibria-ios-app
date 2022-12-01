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
    
    func showErrorAlert(withTitle title: String, message: String)
    func update(data: [CarouselViewModel], inCarouselView carouselView: CarouselView)
}

final class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    
    private var scrollView = UIScrollView()
    private var vContentStackView = UIStackView()
    private var todayCarouselView: CarouselView!
    private var updatesCarouselView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        configureNavigationBarAppearance()
        configureScrollView()
        configureVContentStackView()
        configureTodayCarouselView()
        configureUpdatesCarouselView()
    }
    
    // MARK: - NavigationBarAppearance
    func configureNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    // MARK: - scrollView
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        setScrollViewConstraints()
    }
    
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentGuide.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
        ])
    }
        
    // MARK: - vContentStackView
    func configureVContentStackView() {
        scrollView.addSubview(vContentStackView)
        vContentStackView.axis = .vertical
        vContentStackView.spacing = 10
        setVContentStackViewConstraints()
    }
    
    func setVContentStackViewConstraints() {
        vContentStackView.translatesAutoresizingMaskIntoConstraints = false
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            vContentStackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            vContentStackView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            vContentStackView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            vContentStackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor)
        ])
    }
    
    // MARK: - toDayCarouselView
    func configureTodayCarouselView() {
        let multiplier: CGFloat = 500 / 350
        let cellWidth: CGFloat = 300
        todayCarouselView = CarouselView(withTitle: Strings.HomeModule.Title.today, buttonTitle: Strings.HomeModule.ButtonTitle.allDays, imageSize: CGSize(width: cellWidth, height: cellWidth * multiplier), cellFocusAnimation: true)
        todayCarouselView.delegate = self
        presenter.getDataFor(carouselView: todayCarouselView, viewType: .todayCarouselView)
        vContentStackView.addArrangedSubview(todayCarouselView)
    }
    
    // MARK: - updatesCarouselView
    func configureUpdatesCarouselView() {
        let multiplier: CGFloat = 500 / 350
        let cellWidth: CGFloat = 200
        updatesCarouselView = CarouselView(withTitle: Strings.HomeModule.Title.updates, buttonTitle: Strings.HomeModule.ButtonTitle.all, imageSize: CGSize(width: cellWidth, height: cellWidth * multiplier), cellFocusAnimation: false)
        updatesCarouselView.delegate = self
        presenter.getDataFor(carouselView: updatesCarouselView, viewType: .updatesCarouselView)
        vContentStackView.addArrangedSubview(updatesCarouselView)
    }
    
    func getViewType(fromCarouselView carouselView: CarouselView) -> CarouselViewType {
        switch carouselView {
            case todayCarouselView:
                return .todayCarouselView
            case updatesCarouselView:
                return .updatesCarouselView
            default:
                fatalError("getViewType func does not have all CarouselViewType values")
        }
    }
    
    // MARK: - HomeViewProtocol Functions
    
    func showErrorAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Strings.AlertController.Title.ok, style: .default)
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
        
    func update(data: [CarouselViewModel], inCarouselView carouselView: CarouselView) {
        carouselView.data = data
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

// MARK: - CarouselViewProtocol

extension HomeViewController: CarouselViewProtocol {
    func cellClicked() {
        print("Cell Click")
    }
    
    func titleButtonAction(sender: UIButton) {
        print("Button Action")
        presenter.titleButtonAction()
    }
    
    func getImage(forIndex index: Int, forCarouselView carouselView: CarouselView) {
        let viewType = getViewType(fromCarouselView: carouselView)
        presenter.getImage(forIndex: index, forViewType: viewType, forCarouselView: carouselView)
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
