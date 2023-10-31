//
//  AnimeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 27.10.2023.
//

import UIKit

protocol AnimeViewOutput: AnyObject {
    func navBarBackButtonTapped()
}

final class AnimeView: UIView {
    
    private lazy var navigationBar = UINavigationBar()
    private lazy var navBarItem = UINavigationItem()
    private lazy var scrollView = UIScrollView()
    private lazy var animeImageView = AnimeImageView()
    private lazy var contentVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    private lazy var animeInfoView = AnimeInfoView()
    
    private let animeName: String
    
    private lazy var currentWindow: UIWindow? = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window
    }()
    
    private lazy var animeImageViewHeight: CGFloat = (currentWindow?.bounds.height ?? 0) * 0.55
    private lazy var animeImageViewSmallHeight: CGFloat = animeImageViewHeight * 0.75
    
    private lazy var topSafeAreaHeight: CGFloat = currentWindow?.safeAreaInsets.top ?? 0.0
    
    private var lastContentOffsetY: Double = 0
    private var animeHeightConstraint: NSLayoutConstraint!
    private var animeTopConstraint: NSLayoutConstraint!
    
    private weak var delegate: AnimeViewOutput?
    
    init(delegate: AnimeController, item: AnimeItem) {
        self.delegate = delegate
        self.animeName = item.ruName
        super.init(frame: .zero)
        
        configureView()
        configureNavigationBar()
        configureScrollView()
        configureAnimeImageView(item: item)
        configureAnimeInfoView(item: item, delegate: delegate)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension AnimeView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureNavigationBar() {
        navigationBar.delegate = self
        navigationBar.tintColor = .systemRed
        navigationBar.barTintColor = .systemBackground
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        configureNavBarItem()
        navigationBar.items = [navBarItem]
    }
    
    func configureNavBarItem() {
        let backButtonImage = UIImage(systemName: "chevron.left")?.applyingSymbolConfiguration(.init(weight: .semibold))
        let backBarButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(testBackBarButton))
        navBarItem.leftBarButtonItem = backBarButton
    }
    
    @objc func testBackBarButton() {
        delegate?.navBarBackButtonTapped()
    }
    
    func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(top: animeImageViewHeight, left: 0, bottom: 0, right: 0)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func configureAnimeImageView(item: AnimeItem) {
        update(image: item.image)
    }
    
    func configureAnimeInfoView(item: AnimeItem, delegate: AnimeController) {
        animeInfoView.seriesView.delegate = delegate
        animeInfoView.watchAndDownloadButtonsView.delegate = delegate
        animeInfoView.favoriteAndShareButtonsView.delegate = delegate
        
        animeInfoView.ruNameLabel.text = item.ruName
        animeInfoView.engNameLabel.text = item.engName
        animeInfoView.seasonAndTypeLabel.text = item.seasonAndType
        animeInfoView.genresLabel.text = item.genres
        animeInfoView.descriptionLabel.text = item.description
        animeInfoView.seriesView.subtitleLabel.text = (item.series?.string ?? "") + " " + "серий" //  localizable
    }
    
    func configureLayout() {
        addSubview(scrollView)
        addSubview(navigationBar)
        scrollView.addSubview(animeImageView)
        scrollView.addSubview(contentVStack)
        contentVStack.addArrangedSubview(animeInfoView)
        
        // MARK: navigationBar constraints
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // MARK: scrollVoew constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            frameGuide.topAnchor.constraint(equalTo: topAnchor),
            frameGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentGuide.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
        ])
        
        // MARK: animeImageView constraints
        animeImageView.translatesAutoresizingMaskIntoConstraints = false
        animeTopConstraint = animeImageView.topAnchor.constraint(equalTo: frameGuide.topAnchor)
        animeHeightConstraint = animeImageView.heightAnchor.constraint(equalToConstant: animeImageViewHeight)
        NSLayoutConstraint.activate([
            animeImageView.leadingAnchor.constraint(equalTo: frameGuide.leadingAnchor),
            animeImageView.trailingAnchor.constraint(equalTo: frameGuide.trailingAnchor),
            animeTopConstraint,
            animeHeightConstraint
        ])
        
        // MARK: contentVStack constraints
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentVStack.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentVStack.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentVStack.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            contentVStack.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor)
        ])
    }
}

// MARK: - Internal methods

extension AnimeView {
    func update(image: UIImage?) {
        animeImageView.backgroundImageView.image = image
        animeImageView.imageView.image = image
    }
}

// MARK: - UINavigationBarDelegate

extension AnimeView: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - UIScrollViewDelegate

extension AnimeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupNavBar(scrollView)
        if -scrollView.contentOffset.y >= animeImageViewSmallHeight {
            if animeTopConstraint.constant != 0 {
                animeTopConstraint.constant = 0
            }
            animeHeightConstraint.constant = -scrollView.contentOffset.y
        } else {
            animeTopConstraint.constant -= scrollView.contentOffset.y - lastContentOffsetY
        }
        lastContentOffsetY = scrollView.contentOffset.y
    }
    
    private func setupNavBar(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + topSafeAreaHeight <= 0 {
            navBarItem.title = ""
            navigationBar.isTranslucent = true
        } else {
            navBarItem.title = animeName
            navigationBar.isTranslucent = false
        }
    }
}
