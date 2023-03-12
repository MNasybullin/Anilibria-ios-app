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
    
    var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .fill
        stack.isSkeletonable = true
        return stack
    }()
    
    var headerHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .top
        return stack
    }()
    
    var headerLabel: UILabel = {
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
    
    var animeHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.distribution = .fill
        stack.alignment = .top
        stack.isSkeletonable = true
        return stack
    }()
    
    var animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .fill
        stack.isSkeletonable = true
        return stack
    }()
    
    var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isSkeletonable = true
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
            
            animeImageView.heightAnchor.constraint(equalTo: animeHStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500),
//            animeImageView.heightAnchor.constraint(equalTo: animeImageView.widthAnchor, multiplier: 500 / 350),
            
        ])
    }
    
    private func updateView() {
        if data == nil {
            self.headerButton.isEnabled = false
//            self.showAnimatedSkeleton()
            return
        }
//        hideSkeleton(reloadDataAfter: false)
        headerButton.isEnabled = true
        animeImageView.image = data?.image
        ruNameLabel.text = data?.ruName
        engNameLabel.text = data?.engName
        descriptionLabel.text = data?.description
        delegate?.updateConstraints()
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
