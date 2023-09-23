//
//  RandomAnimeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 11.03.2023.
//

import UIKit
import SkeletonView

protocol RandomAnimeViewDelegate: AnyObject {
    func getRandomAnimeData()
    func viewTapped()
}

final class RandomAnimeView: UIView {
    weak var delegate: RandomAnimeViewDelegate?
    
    private var data: RandomAnimeViewModel? {
        didSet {
            updateView()
        }
    }
    
    lazy var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .fill
        stack.isSkeletonable = true
        return stack
    }()
    
    lazy var headerHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.SearchModule.Title.randomAnime
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemRed
        button.setImage(
            UIImage(systemName: Strings.SearchModule.Image.refresh),
            for: .normal)
        
        button.addAction(UIAction { [weak self] _ in
            self?.data = nil
            self?.delegate?.getRandomAnimeData()
        }, for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    lazy var animeHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .top
        stack.isSkeletonable = true
        return stack
    }()
    
    lazy var animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.isSkeletonable = true
        stack.spacing = 2
        return stack
    }()
    
    lazy var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.isSkeletonable = true
        label.skeletonLineSpacing = 4
        return label
    }()
    
    lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isSkeletonable = true
        label.skeletonTextLineHeight = .relativeToConstraints
        label.skeletonLineSpacing = 4
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        isSkeletonable = true
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
        
        setupConstraints()
        setupTapGR()
        showAnimatedSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    private func setupConstraints() {
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        
        headerHStack.translatesAutoresizingMaskIntoConstraints = false
        headerHStack.heightAnchor.constraint(equalToConstant: titleLabel.font.lineHeight).isActive = true
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        refreshButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        animeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeImageView.heightAnchor.constraint(equalTo: animeHStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500)
        ])
        
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private func setupTapGR() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(animeStackTapped))
        animeHStack.addGestureRecognizer(tapGR)
    }
    
    private func updateView() {
        guard data != nil else {
            self.refreshButton.isEnabled = false
            self.showAnimatedSkeleton()
            return
        }
        
        hideSkeleton(reloadDataAfter: false)
        refreshButton.isEnabled = true
        animeImageView.image = data?.image
        ruNameLabel.text = data?.ruName
        engNameLabel.text = data?.engName
        descriptionLabel.text = data?.description
    }
    
    func update(data: RandomAnimeViewModel) {
        DispatchQueue.main.async {
            self.data = data
        }
    }
    
    @objc private func animeStackTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended && data != nil {
            delegate?.viewTapped()
        }
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct RandomAnimeView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            RandomAnimeView()
        }
        .frame(height: 300)
    }
}

#endif
