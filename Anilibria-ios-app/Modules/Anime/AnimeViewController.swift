//
//  AnimeViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import UIKit

protocol AnimeViewProtocol: AnyObject {
	var presenter: AnimePresenterProtocol! { get set }
    
    func update(image: UIImage)
}

final class AnimeViewController: UIViewController, AnimeViewProtocol {
	var presenter: AnimePresenterProtocol!
    
    private var scrollView: UIScrollView!
    private var animeImageView: AnimeImageView!
    private var contentVStack: UIStackView!
    private var animeInfoView: AnimeInfoView!
    
    private lazy var animeImageViewHeight: CGFloat = self.view.bounds.height / 1.7
    private lazy var animeImageViewSmallHeight: CGFloat = animeImageViewHeight / 1.5
    private var animeHeightConstraint: NSLayoutConstraint!
    private var animeTopConstraint: NSLayoutConstraint!
    private var animeTopFlag: Bool = false
    private var lastContentOffsetY: Double!
    
    private var animeName: String!
    
    private let windowTopSafeAreHeight: CGFloat = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.safeAreaInsets.top ?? 0.0
    }()
    
    private lazy var topSafeAreaHeight: CGFloat = {
        return windowTopSafeAreHeight + (navigationController?.navigationBar.bounds.height ?? 0.0)
    }()
    
    private lazy var navigationBarAppearance: UINavigationBarAppearance = {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowColor = .clear
        return navBarAppearance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        animeName = presenter.getData().ruName
        setupNavBarBackButton()
        configureScrollView()
        configureContentVStack()
        configureAnimeImageView()
        configureAnimeInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarAppearance()
        setupNavBar()
    }
    
    override func viewWillLayoutSubviews() {
        topSafeAreaHeight = windowTopSafeAreHeight + (navigationController?.navigationBar.bounds.height ?? 0.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureNavigationBarAppearance()
    }
    
    private func configureNavigationBarAppearance() {
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    private func setupNavBarBackButton() {
        navigationItem.backButtonTitle = ""
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(top: animeImageViewHeight, left: 0, bottom: 0, right: 0)
        scrollView.showsVerticalScrollIndicator = false
        
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
    
    private func configureAnimeImageView() {
        animeImageView = AnimeImageView()
        scrollView.addSubview(animeImageView)

        animeImageView.translatesAutoresizingMaskIntoConstraints = false
        let frameGuide = scrollView.frameLayoutGuide
        NSLayoutConstraint.activate([
            animeImageView.topAnchor.constraint(equalTo: frameGuide.topAnchor),
            animeImageView.leadingAnchor.constraint(equalTo: frameGuide.leadingAnchor),
            animeImageView.trailingAnchor.constraint(equalTo: frameGuide.trailingAnchor)
        ])
        animeTopConstraint = animeImageView.topAnchor.constraint(equalTo: frameGuide.topAnchor)
        animeTopConstraint.isActive = true
        
        animeHeightConstraint = animeImageView.heightAnchor.constraint(equalToConstant: animeImageViewHeight)
        animeHeightConstraint.isActive = true
    }
    
    private func configureContentVStack() {
        contentVStack = UIStackView()
        scrollView.addSubview(contentVStack)
        contentVStack.axis = .vertical
        
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentVStack.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentVStack.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentVStack.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor)
        ])
    }
    
    private func configureAnimeInfoView() {
        animeInfoView = AnimeInfoView()
        
        animeInfoView.seriesView.delegate = self
        
        let data = presenter.getData()
        animeInfoView.ruNameLabel.text = data.ruName
        animeInfoView.engNameLabel.text = data.engName
        animeInfoView.seasonAndTypeLabel.text = data.seasonAndType
        animeInfoView.genresLabel.text = data.genres
        animeInfoView.descriptionLabel.text = data.description
        animeInfoView.seriesView.subtitleLabel.text = (data.series?.string ?? "") + " " + "серий"
        
        contentVStack.addArrangedSubview(animeInfoView)
    }
    
    func update(image: UIImage) {
        DispatchQueue.main.async {
            self.animeImageView.backgroundImageView.image = image
            self.animeImageView.imageView.image = image
        }
    }
}

// MARK: - SeriesViewDelegate
extension AnimeViewController: SeriesViewDelegate {
    func viewClicked() {
        presenter.seriesViewClicked()
    }
}

// MARK: - UIScrollViewDelegate
extension AnimeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupNavBar()
        if -scrollView.contentOffset.y >= animeImageViewSmallHeight && Int(animeTopConstraint.constant) >= 0 {
            if animeTopConstraint.constant != 0 {
                animeTopConstraint.constant = 0
            }
            if animeTopFlag == false {
                animeTopFlag = true
            }
            animeHeightConstraint.constant = -scrollView.contentOffset.y
        } else if animeTopFlag == true {
            animeTopConstraint.constant -= scrollView.contentOffset.y - lastContentOffsetY
        }
        lastContentOffsetY = scrollView.contentOffset.y
    }
    
    private func setupNavBar() {
        if scrollView.contentOffset.y + topSafeAreaHeight <= 0 {
            navigationController?.navigationBar.standardAppearance.backgroundColor = .clear
            self.title = ""
        } else {
            navigationController?.navigationBar.standardAppearance.backgroundColor = .systemBackground
            self.title = animeName
        }
    }
}
