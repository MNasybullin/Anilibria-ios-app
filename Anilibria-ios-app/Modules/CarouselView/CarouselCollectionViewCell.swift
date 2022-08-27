//
//  CarouselCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray2
        image.image = UIImage(asset: Asset.Assets.defaultTitleImage)
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vStack)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leftAnchor.constraint(equalTo: leftAnchor),
            vStack.rightAnchor.constraint(equalTo: rightAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16)
        ])
    }
}
