//
//  SearchResultsTableViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.03.2023.
//

import UIKit
import SkeletonView

final class SearchResultsTableViewCell: UITableViewCell {
    private enum Constants {
        static let vStackSpacing: CGFloat = 3
        static let hStackSpacing: CGFloat = 6
        static let ruNameLabelFontSize: CGFloat = 17
        static let engNameLabelFontSize: CGFloat = 16
        static let descriptionLabelFontSize: CGFloat = 16
    }
    
    var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.hStackSpacing
        stack.alignment = .top
        stack.isSkeletonable = true
        return stack
    }()
    
    var animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.vStackSpacing
        stack.isSkeletonable = true
        return stack
    }()
    
    var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: Constants.ruNameLabelFontSize,
            weight: .medium)
        label.textColor = .label
        label.isSkeletonable = true
        return label
    }()
    
    var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: Constants.engNameLabelFontSize,
            weight: .regular)
        label.textColor = .systemGray
        label.isSkeletonable = true
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: Constants.descriptionLabelFontSize,
            weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 0
        label.skeletonLineSpacing = 4
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
        configureLabelsForSkeleton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if animeImageView.sk.isSkeletonActive == false {
            animeImageView.showAnimatedSkeleton(transition: .none)
        }
        animeImageView.image = nil
        configureLabelsForSkeleton()
//        ruNameLabel.text = nil
//        engNameLabel.text = nil
//        descriptionLabel.text = nil
    }
}

// MARK: - Private methods

private extension SearchResultsTableViewCell {
    func configureView() {
        backgroundColor = .systemBackground
        contentView.isSkeletonable = true
        isSkeletonable = true
    }
    
    func configureLabelsForSkeleton() {
        let text = "For SkeletonView For SkeletonView For SkeletonView For SkeletonView For SkeletonView For SkeletonView For SkeletonView v For SkeletonView For SkeletonView For SkeletonView For SkeletonView For SkeletonView"
        ruNameLabel.text = text
        engNameLabel.text = text
        descriptionLabel.text = text
    }
    
    func configureLayout() {
        contentView.addSubview(hStack)

        hStack.addArrangedSubview(animeImageView)
        hStack.addArrangedSubview(vStack)

        vStack.addArrangedSubview(ruNameLabel)
        vStack.addArrangedSubview(engNameLabel)
        vStack.addArrangedSubview(descriptionLabel)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        animeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animeImageView.heightAnchor.constraint(equalTo: hStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500)
        ])
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
//        // Для skeletonView
//        let ruNameLabelHeight = ruNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: ruNameLabel.font.lineHeight)
//        let engNameLabelHeight = engNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: engNameLabel.font.lineHeight)
//        let descriptionLabelHeight = descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: descriptionLabel.font.lineHeight * 3)
//        ruNameLabelHeight.priority = .defaultHigh
//        engNameLabelHeight.priority = .defaultHigh
//        descriptionLabelHeight.priority = .defaultHigh
//        NSLayoutConstraint.activate([
//            ruNameLabelHeight,
//            engNameLabelHeight,
//            descriptionLabelHeight
//        ])
    }
}

// MARK: - Internal methods

extension SearchResultsTableViewCell {
    func configureCell(item: SearchResultsItem) {
        if item.image == nil {
            if animeImageView.sk.isSkeletonActive == false {
                animeImageView.showAnimatedSkeleton()
            }
        } else if animeImageView.sk.isSkeletonActive == true {
            animeImageView.hideSkeleton(reloadDataAfter: false)
        }
        animeImageView.image = item.image
        ruNameLabel.text = item.ruName
        engNameLabel.text = item.engName
        descriptionLabel.text = item.description
    }
}
