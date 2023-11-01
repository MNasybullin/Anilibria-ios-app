//
//  RandomAnimeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit
import SkeletonView

protocol RandomAnimeViewDelegate: AnyObject {
    func refreshButtonDidTapped()
    func viewTapped()
}

final class RandomAnimeView: UIView {
    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.isSkeletonable = true
        return stack
    }()
    
    private lazy var headerHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.RandomAnimeModule.Title.randomAnime
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemRed
        button.setImage(
            UIImage(systemName: Strings.RandomAnimeModule.Image.refresh),
            for: .normal)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.refreshButtonDidTapped()
        }, for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    private lazy var animeHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .top
        stack.isSkeletonable = true
        return stack
    }()
    
    private lazy var animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.isSkeletonable = true
        stack.spacing = 2
        return stack
    }()
    
    private lazy var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.isSkeletonable = true
        label.skeletonLineSpacing = 4
        return label
    }()
    
    private lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isSkeletonable = true
        label.skeletonLineSpacing = 4
        return label
    }()
    
    weak var delegate: RandomAnimeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
        configureTapGR()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension RandomAnimeView {
    func configureView() {
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    func configureLayout() {
        addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(headerHStack)
        mainVStack.addArrangedSubview(animeHStack)
        
        headerHStack.addArrangedSubview(titleLabel)
        headerHStack.addArrangedSubview(refreshButton)
        
        animeHStack.addArrangedSubview(animeImageView)
        animeHStack.addArrangedSubview(vStack)
        
        vStack.addArrangedSubview(ruNameLabel)
        vStack.addArrangedSubview(engNameLabel)
        vStack.addArrangedSubview(descriptionLabel)
        
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        
        headerHStack.translatesAutoresizingMaskIntoConstraints = false
        headerHStack.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight).isActive = true
        
        refreshButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        animeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeImageView.heightAnchor.constraint(equalTo: animeHStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500)
        ])
        
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        // Для skeletonView
        ruNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: ruNameLabel.font.lineHeight).isActive = true
        engNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: engNameLabel.font.lineHeight).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: descriptionLabel.font.lineHeight * 3).isActive = true
    }
    
    func configureTapGR() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(animeStackTapped))
        animeHStack.addGestureRecognizer(tapGR)
    }
    
    @objc func animeStackTapped(sender: UITapGestureRecognizer) {
//        if sender.state == .ended && data != nil {
            delegate?.viewTapped()
//        }
    }
}

// MARK: - Internal methods

extension RandomAnimeView {
    func updateView(data: RandomAnimeItem) {
        animeImageView.image = data.image
        ruNameLabel.text = data.ruName
        engNameLabel.text = data.engName
        descriptionLabel.text = data.description
    }
    
    func showSkeleton() {
        showAnimatedSkeleton()
    }
    
    func hideSkeleton() {
        hideSkeleton(reloadDataAfter: false)
    }
    
    func configureRefreshButton(isEnabled status: Bool) {
        refreshButton.isEnabled = status
    }
}
