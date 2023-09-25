//
//  PostersListCollectionViewHeader.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import UIKit
import SkeletonView

final class PostersListCollectionViewHeader: UICollectionReusableView {
    // MARK: - Static Constants
    static let titleLableHeight: CGFloat = labelFont.lineHeight * CGFloat(labelNumberOfLines)
    
    static let labelFont = UIFont.systemFont(ofSize: 26, weight: .semibold)
    static let labelNumberOfLines = 1
    
    private let leadingTrainlingConstants: CGFloat = 8
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = labelFont
        label.numberOfLines = labelNumberOfLines
        label.textColor = .label
        label.textAlignment = .left
        label.isSkeletonable = true
        label.linesCornerRadius = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        isSkeletonable = true
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingTrainlingConstants),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: leadingTrainlingConstants),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
