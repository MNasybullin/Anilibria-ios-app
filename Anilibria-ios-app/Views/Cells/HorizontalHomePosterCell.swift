//
//  HorizontalHomePosterCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.12.2023.
//

import UIKit
import SkeletonView

final class HorizontalHomePosterCell: UICollectionViewCell {
    private enum Constants {
        static let stackSpacing: CGFloat = 6
        static let imageViewCornerRadius: CGFloat = 12
        static let imageViewRatio: CGFloat =  480 / 270
        static let titleLabelFontSize: CGFloat = 16
        static let titleLabelNumberOfLines: Int = 2
        static let titleLabelLinesCornerRadius: Int = 5
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
        imageView.contentMode = .scaleAspectFill
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
        label.linesCornerRadius = Constants.titleLabelLinesCornerRadius
        return label
    }()
    
    private var imageUrlString = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension HorizontalHomePosterCell {
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

extension HorizontalHomePosterCell {
    func configureCell(item: HomePosterItem) {
        if sk.isSkeletonActive == true {
            hideSkeleton(reloadDataAfter: false)
        }
        imageView.image = item.image
        if item.image == nil {
            imageView.showAnimatedSkeleton(transition: .none)
        }
        
        titleLabel.text = item.name
        imageUrlString = item.imageUrlString
    }
    
    func configureSkeletonCell() {
        imageView.image = nil
        titleLabel.text = Strings.skeletonTextPlaceholder
        showAnimatedSkeleton(transition: .none)
    }
    
    func setImage(_ image: UIImage, urlString: String) {
        if urlString == imageUrlString {
            imageView.hideSkeleton(reloadDataAfter: false)
            imageView.image = image
        }
    }
}
