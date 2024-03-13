//
//  PosterCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.10.2023.
//

import UIKit
import SkeletonView

class PosterCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let stackSpacing: CGFloat = 6
        static let imageViewCornerRadius: CGFloat = 12
        static let titleLabelFontSize: CGFloat = 16
        static let titleLabelNumberOfLines: Int = 2
        static let titleLabelLinesCornerRadius: Int = 5
    }
    
    var imageViewRatio: CGFloat {
        350 / 500
    }
        
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.isSkeletonable = true
        return stack
    }()
    
    private (set) lazy var imageView: UIImageView = {
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
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.titleLabelLinesCornerRadius
        return label
    }()
    
    private var imageUrlString = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        imageViewAdditionallyConfigure(imageView)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageViewAdditionallyConfigure(_ imageView: UIImageView) { }
}

// MARK: - Private methods

private extension PosterCollectionViewCell {
    func configureView() {
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    func configureConstraints() {
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
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageViewRatio)
        ])
    }
}

// MARK: - Internal methods

extension PosterCollectionViewCell {
    func configureCell(item: any PosterItem) {
        if item.image == nil {
            imageView.showAnimatedSkeleton(transition: .none)
        } else {
            imageView.image = item.image
            imageView.hideSkeleton(reloadDataAfter: false)
        }
        
        titleLabel.text = item.name
        imageUrlString = item.imageUrlString
    }
    
    func setImage(_ image: UIImage, urlString: String) {
        if urlString == imageUrlString {
            imageView.image = image
            imageView.hideSkeleton(reloadDataAfter: false)
        }
    }
    
    func imageViewStopSkeletonAnimation() {
        imageView.stopSkeletonAnimation()
    }
}
