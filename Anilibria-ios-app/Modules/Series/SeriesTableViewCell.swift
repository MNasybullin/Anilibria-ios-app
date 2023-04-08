//
//  SeriesTableViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 07.04.2023.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        return stack
    }()
    
    lazy var seriesImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var labelsVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .top
        return stack
    }()
    
    lazy var indicatorAndTitleHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    lazy var titleLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = titleLabelFont
        label.textColor = .label
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(hStack)
        setupHStack()
        
        hStack.addArrangedSubview(seriesImageView)
        setupSeriesImageView()
        
        hStack.addArrangedSubview(labelsVStack)
        
        labelsVStack.addArrangedSubview(indicatorAndTitleHStack)
        labelsVStack.addArrangedSubview(subtitleLabel)
        
        indicatorAndTitleHStack.addArrangedSubview(indicatorImageView)
        indicatorAndTitleHStack.addArrangedSubview(titleLabel)
        
        setupIndicatorImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHStack() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func setupSeriesImageView() {
        seriesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seriesImageView.widthAnchor.constraint(equalTo: seriesImageView.heightAnchor, multiplier: (1920/1080)),
            seriesImageView.widthAnchor.constraint(lessThanOrEqualTo: hStack.widthAnchor, multiplier: (1/2.5))
        ])
    }
    
    private func setupIndicatorImageView() {
        indicatorImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicatorImageView.heightAnchor.constraint(equalTo: indicatorImageView.widthAnchor, multiplier: 1),
            indicatorImageView.heightAnchor.constraint(equalToConstant: titleLabelFont.lineHeight / 2)
        ])
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct SeriesTableViewCellView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            SeriesTableViewCell()
        }
    }
}

#endif
