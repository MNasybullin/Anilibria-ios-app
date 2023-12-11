//
//  SeriesTableViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 07.04.2023.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {
    private enum Constants {
        static let mainStackSpacing: CGFloat = 8
        static let secondaryStackSpacing: CGFloat = 6
        static let titleLabelFontSize: CGFloat = 16
        static let subtitleLabelFontSize: CGFloat = 14
    }
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.mainStackSpacing
        stack.alignment = .top
        return stack
    }()
    
    private lazy var seriesImageView = UIImageView()
    
    private lazy var labelsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.secondaryStackSpacing
        stack.alignment = .top
        return stack
    }()
    
    private lazy var indicatorAndTitleHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.secondaryStackSpacing
        stack.alignment = .center
        return stack
    }()
    
    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelFontSize, 
                                       weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.subtitleLabelFontSize,
                                       weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var imageUrlString = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureView() {
        backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        contentView.addSubview(hStack)
        
        hStack.addArrangedSubview(seriesImageView)
        hStack.addArrangedSubview(labelsVStack)
        
        labelsVStack.addArrangedSubview(indicatorAndTitleHStack)
        labelsVStack.addArrangedSubview(subtitleLabel)
        
        indicatorAndTitleHStack.addArrangedSubview(indicatorImageView)
        indicatorAndTitleHStack.addArrangedSubview(titleLabel)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        seriesImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seriesImageView.widthAnchor.constraint(equalTo: seriesImageView.heightAnchor, multiplier: (1920/1080)),
            seriesImageView.widthAnchor.constraint(lessThanOrEqualTo: hStack.widthAnchor, multiplier: 0.4)
        ])
        
        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor, multiplier: 1),
            indicatorImageView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.5)
        ])
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func configureCell(item: Playlist) {
        if let image = item.image {
            seriesImageView.image = image
        } else {
            seriesImageView.image = UIImage(asset: Asset.Assets.blankImage)
        }
        titleLabel.text = item.serieString
        subtitleLabel.text = item.createdDateString
        imageUrlString = item.previewUrl
    }
    
    func setImage(_ image: UIImage, urlString: String) {
        if urlString == imageUrlString {
            seriesImageView.image = image
        }
    }
}
