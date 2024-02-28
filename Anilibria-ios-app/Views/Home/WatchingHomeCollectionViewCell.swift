//
//  WatchingHomeCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.02.2024.
//

import UIKit
import SkeletonView

final class WatchingHomeCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let stackSpacing: CGFloat = 2
        static let imageViewCornerRadius: CGFloat = 12
        static let titleLabelFontSize: CGFloat = 16
        static let subtitleLabelFontSize: CGFloat = 14
        static let titleLabelLinesCornerRadius: Int = 5
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
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
    
    private let imageViewRatio: CGFloat = 1920 / 1080
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize,
                                       weight: .medium)
        label.textColor = .secondaryLabel
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.titleLabelLinesCornerRadius
        label.skeletonTextNumberOfLines = 1
        label.lastLineFillPercent = 100
        label.text = "Skeleton"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.subtitleLabelFontSize,
                                       weight: .medium)
        label.textColor = .tertiaryLabel
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.titleLabelLinesCornerRadius
        label.skeletonTextNumberOfLines = 1
        label.lastLineFillPercent = 40
        label.text = "Skeleton"
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension WatchingHomeCollectionViewCell {
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
            CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
            CGAffineTransform.identity
        })
    }
    
    func setupView() {
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    func setupLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageViewRatio)
        ])
    }
}

// MARK: - Internal methods

extension WatchingHomeCollectionViewCell {
    func configureCell(item: HomeWatchingItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        imageView.image = item.image
    }
}
