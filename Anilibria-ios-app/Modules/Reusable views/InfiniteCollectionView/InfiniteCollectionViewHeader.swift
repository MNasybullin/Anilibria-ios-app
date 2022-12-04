//
//  InfiniteCollectionViewHeader.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.12.2022.
//

import UIKit
import SkeletonView

final class InfiniteCollectionViewHeader: UICollectionReusableView {
    // MARK: - Static Constants
    static let titleLableHeight: CGFloat = labelFont.lineHeight * CGFloat(labelNumberOfLines)
    
    static let labelFont = UIFont.systemFont(ofSize: 26, weight: .semibold)
    static let labelNumberOfLines = 1
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = labelFont
        label.numberOfLines = labelNumberOfLines
//        label.backgroundColor = .yellow //
        label.textColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.linesCornerRadius = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        isSkeletonable = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.lineHeight * CGFloat(titleLabel.numberOfLines))
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
