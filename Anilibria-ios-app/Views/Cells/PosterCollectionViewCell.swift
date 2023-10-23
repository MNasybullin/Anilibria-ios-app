//
//  PosterCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit
import SkeletonView

final class PosterCollectionViewCell: UICollectionViewCell {
    private enum Constants {
        static let stackSpacing: CGFloat = 6
        static let imageViewCornerRadius: CGFloat = 12
        static let titleLabelFontSize: CGFloat = 16
        static let titleLabelNumberOfLines: Int = 2
        static let imageViewRatio: CGFloat =  350 / 500
    }
        
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.isSkeletonable = true
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = Float(Constants.imageViewCornerRadius)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize,
                                       weight: .medium)
        label.numberOfLines = Constants.titleLabelNumberOfLines
        label.textColor = .systemGray
        label.textAlignment = .left
        label.isSkeletonable = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if imageView.sk.isSkeletonActive == false {
            imageView.showAnimatedSkeleton(transition: .none)
        }
        imageView.image = nil
        titleLabel.text = nil
    }
}

// MARK: - Private methods

private extension PosterCollectionViewCell {
    private func configureView() {
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    private func configureConstraints() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(imageView)
        contentStackView.addArrangedSubview(titleLabel)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStackViewBottomAnchor = contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        contentStackViewBottomAnchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackViewBottomAnchor,
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: Constants.imageViewRatio)
        ])
    }
}

// MARK: - Internal methods

extension PosterCollectionViewCell {
    func configureCell(model: HomeModel) {
        if model.image == nil {
            if imageView.sk.isSkeletonActive == false {
                imageView.showAnimatedSkeleton()
            }
        } else if imageView.sk.isSkeletonActive == true {
            imageView.hideSkeleton(reloadDataAfter: false)
        }
        
        if model.name.isEmpty {
            if titleLabel.sk.isSkeletonActive == false {
                titleLabel.showAnimatedSkeleton()
            }
        } else if titleLabel.sk.isSkeletonActive == true {
            titleLabel.hideSkeleton(reloadDataAfter: false)
        }
        
        imageView.image = model.image
        titleLabel.text = model.name
    }
}
