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
    func updateConstraints()
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
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        stack.alignment = .top
        return stack
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.SearchModule.Title.randomAnime
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Strings.SearchModule.Image.refresh), for: .normal)
        button.addTarget(self, action: #selector(headerButtonClicked), for: .touchUpInside)
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        return stack
    }()
    
    lazy var ruNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Skeleton placeholder"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 1
        return label
    }()
    
    lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Skeleton placeholder"
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
        label.skeletonTextNumberOfLines = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.isSkeletonable = true
        self.addSubview(mainVStack)
        
        mainVStack.addArrangedSubview(headerHStack)
        mainVStack.addArrangedSubview(animeHStack)
        
        headerHStack.addArrangedSubview(headerLabel)
        headerHStack.addArrangedSubview(headerButton)
        
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
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            headerHStack.heightAnchor.constraint(equalToConstant: headerLabel.font.lineHeight),
            
            headerButton.heightAnchor.constraint(equalTo: headerHStack.heightAnchor),
            headerButton.widthAnchor.constraint(equalTo: headerButton.heightAnchor),
            
            animeImageView.heightAnchor.constraint(equalTo: animeHStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500)
        ])
    }
    
    private func setupTapGR() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(animeStackTapped))
        animeHStack.addGestureRecognizer(tapGR)
    }
    
    private func updateView() {
        guard data != nil else {
            self.headerButton.isEnabled = false
            self.showAnimatedSkeleton()
            return
        }
        
        hideSkeleton(reloadDataAfter: false)
        headerButton.isEnabled = true
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
    
    @objc func headerButtonClicked(sender: UIButton) {
        data = nil
        delegate?.getRandomAnimeData()
    }
    
    @objc func animeStackTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("animeView tapped")
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
