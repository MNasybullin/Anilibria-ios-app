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
    
    private lazy var serieImageView = SerieImageView()
    
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
        
        let originalImage = UIImage(systemName: "circle.fill")?.withTintColor(.systemRed)
        let scaledSize = CGSize(width: originalImage!.size.width / 2, height: originalImage!.size.height / 2)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            originalImage!.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        imageView.image = scaledImage
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
        
        hStack.addArrangedSubview(serieImageView)
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
        
        serieImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            serieImageView.widthAnchor.constraint(equalTo: serieImageView.heightAnchor, multiplier: (1920/1080)),
            serieImageView.widthAnchor.constraint(lessThanOrEqualTo: hStack.widthAnchor, multiplier: 0.4)
        ])
    }
    
    func configureCell(item: Playlist, duration: Double? = nil, playbackTime: Double? = nil) {
        if let image = item.image {
            serieImageView.image = image
        } else {
            serieImageView.image = UIImage(asset: Asset.Assets.blankImage)
        }
        titleLabel.text = item.serieString
        subtitleLabel.text = item.createdDateString
        imageUrlString = item.previewUrl
        
        if let duration, let playbackTime {
            serieImageView.setupWatchingProgress(withDuration: duration, playbackTime: playbackTime)
            indicatorImageView.isHidden = true
        } else {
            serieImageView.watchingProgressIsHidden = true
            indicatorImageView.isHidden = false
        }
    }
    
    func setImage(_ image: UIImage, urlString: String) {
        if urlString == imageUrlString {
            serieImageView.image = image
        }
    }
}
