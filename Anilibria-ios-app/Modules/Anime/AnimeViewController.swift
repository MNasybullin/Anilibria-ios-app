//
//  AnimeViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import UIKit

protocol AnimeViewProtocol: AnyObject {
	var presenter: AnimePresenterProtocol! { get set }
}

final class AnimeViewController: UIViewController, AnimeViewProtocol {
	var presenter: AnimePresenterProtocol!
    
    private var scrollView: UIScrollView!
    private var animeImageView: AnimeImageView!
    private var contentVStack: UIStackView!
    private var animeInfoView: AnimeInfoView!
    
    private lazy var animeImageViewHeight: CGFloat = self.view.frame.height / 1.7
    private lazy var animeImageViewSmallHeight: CGFloat = animeImageViewHeight / 1.5
    private var animeHeightConstraint: NSLayoutConstraint!
    private var animeTopConstraint: NSLayoutConstraint!
    private var animeTopFlag: Bool = false
    private var lastContentOffsetY: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureContentVStack()
        configureAnimeImageView()
        configureAnimeInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        contentVStack.addArrangedSubview(animeInfoView)
    }
}

// MARK: - UIScrollViewDelegate
extension AnimeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct AnimeViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            AnimeRouter.start(withNavigationController: UINavigationController()).entry
        }
    }
}

#endif
