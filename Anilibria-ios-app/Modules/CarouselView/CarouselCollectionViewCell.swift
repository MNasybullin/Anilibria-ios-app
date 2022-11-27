//
//  CarouselCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.08.2022.
//

import UIKit

final class CarouselCollectionViewCell: UICollectionViewCell {
    // MARK: - Public Static Constants
    public static let stackSpacing: CGFloat = 6
    public static let titleLabelHeight: CGFloat = 30
    // del top
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .fill
        stack.backgroundColor = .green
        return stack
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = .blue
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.backgroundColor = .yellow
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
        contentView.addSubview(vStack)
        setupConstraints()
    
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
