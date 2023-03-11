//
//  RandomAnimeView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 11.03.2023.
//

import UIKit

protocol RandomAnimeViewDelegate: AnyObject {
    func getRandomAnimeData()
}

final class RandomAnimeView: UIView {
    weak var delegate: RandomAnimeViewDelegate?
    
    var data: RandomAnimeViewModel? {
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
        stack.isSkeletonable = true
        return stack
    }()
    
    lazy var headerHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fill
        return stack
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Случайное аниме"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    lazy var headerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.addTarget(self, action: #selector(headerButtonClicked), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
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
        stack.spacing = 6
        stack.distribution = .fill
        stack.isSkeletonable = true
        return stack
    }()
    
    lazy var ruNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
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
        showAnimatedSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            animeImageView.heightAnchor.constraint(equalTo: animeHStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500)
        ])
    }
    
    private func updateView() {
        DispatchQueue.main.async {
            guard let data = self.data else {
                self.headerButton.isEnabled = false
                self.showAnimatedSkeleton()
                return
            }
            print(data)
            self.animeImageView.image = data.image
            self.ruNameLabel.text = data.ruName
            self.engNameLabel.text = data.engName
            self.descriptionLabel.text = data.description
            self.headerButton.isEnabled = true
            self.hideSkeleton(reloadDataAfter: false)
        }
    }
    
    @objc func headerButtonClicked(sender: UIButton) {
        data = nil
        delegate?.getRandomAnimeData()
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
