//
//  CarouselCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit
import SkeletonView

final class CarouselCollectionViewCell: UICollectionViewCell {
    // MARK: - Static Constants
    static let stackSpacing: CGFloat = 6
    static let titleLabelHeight: CGFloat = labelFont.lineHeight * CGFloat(labelNumberOfLines) + 0.1
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = stackSpacing
        stack.distribution = .fill
        stack.isSkeletonable = true
        return stack
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.isSkeletonable = true
        image.skeletonCornerRadius = 12
        return image
    }()
    
    static let labelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let labelNumberOfLines = 2
    
    var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = stackSpacing
        stack.distribution = .fill
        stack.isSkeletonable = true
        stack.alignment = .top
        return stack
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = labelFont
        label.numberOfLines = labelNumberOfLines
        label.textColor = .systemGray
        label.textAlignment = .left
        label.linesCornerRadius = 5
        label.isSkeletonable = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vStack)
        isSkeletonable = true
        
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(labelStack)
        
        labelStack.addArrangedSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 350 / 500)
        ])
    }
}
