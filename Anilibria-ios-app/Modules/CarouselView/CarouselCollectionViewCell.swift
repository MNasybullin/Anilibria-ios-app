//
//  CarouselCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Static Constants
    public static let stackSpacing: CGFloat = 5
    public static let titleLabelHeight: CGFloat = 41
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = stackSpacing
        return stack
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray2
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
//        label.font.lineHeight
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
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
            
            titleLabel.heightAnchor.constraint(equalToConstant: CarouselCollectionViewCell.titleLabelHeight)
        ])
    }
}
