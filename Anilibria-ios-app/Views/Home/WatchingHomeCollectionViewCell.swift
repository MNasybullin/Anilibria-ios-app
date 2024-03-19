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
        static let titleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let subtitleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
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
    
    private lazy var imageView: EpisodeImageView = {
        let imageView = EpisodeImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = Float(Constants.imageViewCornerRadius)
        return imageView
    }()
    
    class var imageViewRatio: CGFloat {
        1920 / 1080
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = .secondaryLabel
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.titleLabelLinesCornerRadius
        label.lastLineFillPercent = 100
        label.text = "Skeleton"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.subtitleFont
        label.textColor = .tertiaryLabel
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.titleLabelLinesCornerRadius
        label.lastLineFillPercent = 40
        label.text = "Skeleton"
        return label
    }()
    
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
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: Self.imageViewRatio)
        ])
    }
}

// MARK: - Internal methods

extension WatchingHomeCollectionViewCell {
    func configureCell(item: HomeWatchingItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        imageView.image = item.image
        imageView.setupWatchingProgress(withDuration: item.duration, playbackTime: item.playbackPosition)
    }
}

// MARK: - HomeCollectionViewLayoutCellConfigurable

extension WatchingHomeCollectionViewCell: HomeCollectionViewLayoutCellConfigurable {
    static var cellHeightWithoutImage: CGFloat {
        let titleHeight = Constants.titleFont.lineHeight
        let subtitleHeight = Constants.subtitleFont.lineHeight
        let gap = 1.0
        let spacing = Constants.stackSpacing
        return spacing + titleHeight + spacing + subtitleHeight + gap
    }
}
