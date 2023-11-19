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
        static let vStackSpacing: CGFloat = 2
        static let hStackSpacing: CGFloat = 6
        static let ruNameLabelFontSize: CGFloat = 17
        static let engNameLabelFontSize: CGFloat = 16
        static let descriptionLabelFontSize: CGFloat = 16
    }
    
    private var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.hStackSpacing
        stack.alignment = .top
        stack.isSkeletonable = true
        return stack
    }()
    
    private var animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.vStackSpacing
        stack.isSkeletonable = true
        return stack
    }()
    
    private var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: Constants.ruNameLabelFontSize,
            weight: .medium)
        label.textColor = .label
        label.isSkeletonable = true
        return label
    }()
    
    private var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: Constants.engNameLabelFontSize,
            weight: .regular)
        label.textColor = .systemGray
        label.isSkeletonable = true
        return label
    }()
    
    private var descriptionLabel: UILabel = {
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
    
    private var imageUrlString = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
        configureLabelsForSkeleton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let text = Strings.skeletonTextPlaceholder
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
    }
}

// MARK: - Internal methods

extension SearchResultsTableViewCell {
    func configureCell(item: SearchResultsItem) {
        animeImageView.image = item.image
        if item.image == nil {
            animeImageView.showAnimatedSkeleton(transition: .none)
        }
        
        ruNameLabel.text = item.ruName
        engNameLabel.text = item.engName
        descriptionLabel.text = item.description
        imageUrlString = item.imageUrlString
    }
    
    func setImage(_ image: UIImage, urlString: String) {
        if urlString == imageUrlString {
            animeImageView.hideSkeleton(reloadDataAfter: false)
            animeImageView.image = image
        }
    }
}
