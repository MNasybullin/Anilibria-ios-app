//
//  ScheduleHeaderSupplementaryView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit
import SkeletonView

final class ScheduleHeaderSupplementaryView: UICollectionReusableView {
    private enum Constants {
        static let labelFontSize: CGFloat = 24
        static let linesCornerRadius: Int = 5
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: Constants.labelFontSize,
            weight: .semibold)
        label.textAlignment = .left
        label.text = "For SkeletonView text"
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.linesCornerRadius
        label.skeletonTextLineHeight = SkeletonTextLineHeight.relativeToFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        isSkeletonable = true
        backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Internal methods

extension ScheduleHeaderSupplementaryView {
    func configureView(titleLabelText: String) {
        titleLabel.text = titleLabelText
    }
}
