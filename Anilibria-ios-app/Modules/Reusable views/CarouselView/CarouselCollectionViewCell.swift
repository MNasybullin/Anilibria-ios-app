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
    static let titleLableHeight: CGFloat = labelFont.lineHeight * CGFloat(labelNumberOfLines)
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = stackSpacing
        stack.distribution = .fill
//        stack.backgroundColor = .green //
        stack.isSkeletonable = true
        return stack
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
//        image.backgroundColor = .blue //
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.isSkeletonable = true
        return image
    }()
    
    static let labelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let labelNumberOfLines = 2
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = labelFont
        label.numberOfLines = labelNumberOfLines
//        label.backgroundColor = .yellow // 
        label.textColor = .systemGray
        label.textAlignment = .left
        label.linesCornerRadius = 5
        label.isSkeletonable = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
        contentView.addSubview(vStack)
        setupConstraints()
        isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.lineHeight * CGFloat(titleLabel.numberOfLines))
        ])
    }
}
