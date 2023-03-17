//
//  HomeViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.07.2022.
//

import Foundation
import UIKit
import Combine

protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol! { get set }
    
    func showErrorAlert(with title: String, message: String)
    func update(data: [CarouselViewModel], inCarouselView carouselView: CarouselView)
    func update(image: UIImage, for indexPath: IndexPath, inCarouselView carouselView: CarouselView)
    func refreshControlEndRefreshing()
}

final class HomeViewController: UIViewController, HomeViewProtocol {
    var presenter: HomePresenterProtocol!
    
    private var scrollView = UIScrollView()
    private var vContentStackView = UIStackView()
    private var todayCarouselView: CarouselView!
    private var updatesCarouselView: CarouselView!
    
    private var cancellable: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        configureNavigationBarAppearance()
        configureScrollView()
        configureRefreshControl()
        configureVContentStackView()
        configureTodayCarouselView()
        configureUpdatesCarouselView()
        subscribeToNetworkMonitor()
    }
    
    private func subscribeToNetworkMonitor() {
        cancellable = NetworkMonitor.shared.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                if isConnected == true {
                    self.programaticallyBeginRefreshing()
                }
            }
    }
    
    // MARK: - NavigationBarAppearance
    private func configureNavigationBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    // MARK: - scrollView
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        setScrollViewConstraints()
    }
    
    private func setScrollViewConstraints() {
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
    
    // MARK: - RefreshControl
    private func configureRefreshControl() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        guard NetworkMonitor.shared.isConnected == true else {
            RootViewController.shared.showFlashNetworkActivityView()
            refreshControlEndRefreshing()
            return
        }
        todayCarouselView.refreshData()
        updatesCarouselView.refreshData()
    }
    
    private func programaticallyBeginRefreshing() {
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.beginRefreshing()
            let offsetPoint = CGPoint(x: 0, y: self.scrollView.contentOffset.y - (self.scrollView.refreshControl?.frame.size.height ?? 0))
            self.scrollView.setContentOffset(offsetPoint, animated: true)
            self.handleRefreshControl()
        }
    }
    
    func refreshControlEndRefreshing() {
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
        
    // MARK: - vContentStackView
    private func configureVContentStackView() {
        scrollView.addSubview(vContentStackView)
        vContentStackView.axis = .vertical
        vContentStackView.spacing = 10
        setVContentStackViewConstraints()
    }
    
    private func setVContentStackViewConstraints() {
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
    private func configureTodayCarouselView() {
        let multiplier: CGFloat = 500 / 350
        let cellWidth: CGFloat = 300
        todayCarouselView = CarouselView(withTitle: Strings.HomeModule.Title.today, buttonTitle: Strings.HomeModule.ButtonTitle.allDays, imageSize: CGSize(width: cellWidth, height: cellWidth * multiplier), cellFocusAnimation: true)
        todayCarouselView.delegate = self
        vContentStackView.addArrangedSubview(todayCarouselView)
    }
    
    // MARK: - updatesCarouselView
    private func configureUpdatesCarouselView() {
        let multiplier: CGFloat = 500 / 350
        let cellWidth: CGFloat = 200
        updatesCarouselView = CarouselView(withTitle: Strings.HomeModule.Title.updates, buttonTitle: nil, imageSize: CGSize(width: cellWidth, height: cellWidth * multiplier), cellFocusAnimation: false)
        updatesCarouselView.delegate = self
        vContentStackView.addArrangedSubview(updatesCarouselView)
    }
    
    private func getViewType(fromCarouselView carouselView: CarouselView) -> CarouselViewType {
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
    
    func showErrorAlert(with title: String, message: String) {
        Alert.showErrorAlert(on: self, with: title, message: message)
    }
        
    func update(data: [CarouselViewModel], inCarouselView carouselView: CarouselView) {
        carouselView.updateData(data)
    }
    
    func update(image: UIImage, for indexPath: IndexPath, inCarouselView carouselView: CarouselView) {
        carouselView.updateImage(image, for: indexPath)
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

// MARK: - CarouselViewProtocol

extension HomeViewController: CarouselViewProtocol {
    func getData(for carouselView: CarouselView) {
        let viewType = getViewType(fromCarouselView: carouselView)
        presenter.getDataFor(carouselView: carouselView, viewType: viewType)
    }
    
    func cellClicked() {
        print("Cell Click")
    }
    
    func titleButtonAction(sender: UIButton, carouselView: CarouselView) {
        let viewType = getViewType(fromCarouselView: carouselView)
        presenter.titleButtonAction(viewType: viewType)
    }
    
    func getImage(forIndexPath indexPath: IndexPath, forCarouselView carouselView: CarouselView) {
        let viewType = getViewType(fromCarouselView: carouselView)
        presenter.getImage(forIndexPath: indexPath, forViewType: viewType, forCarouselView: carouselView)
    }
}

// MARK: - ScrollableViewProtocol

extension HomeViewController: ScrollableViewProtocol {
    func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -(scrollView.adjustedContentInset.top)), animated: true)
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
