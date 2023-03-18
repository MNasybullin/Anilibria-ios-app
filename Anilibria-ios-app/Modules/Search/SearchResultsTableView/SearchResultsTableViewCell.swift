//
//  SearchResultsTableViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.03.2023.
//

import UIKit
import SkeletonView

final class SearchResultsTableViewCell: UITableViewCell {
    static let vStackSpacing: CGFloat = 3
    static let hStackSpacing: CGFloat = 6
    
    var hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = hStackSpacing
        stack.distribution = .fill
        stack.alignment = .top
        stack.isSkeletonable = true
        return stack
    }()
    
    var animeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = vStackSpacing
        stack.distribution = .fill
        stack.isSkeletonable = true
        return stack
    }()
    
    var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: label.font.lineHeight).isActive = true
        return label
    }()
    
    var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: label.font.lineHeight).isActive = true
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(hStack)

        hStack.addArrangedSubview(animeImageView)
        hStack.addArrangedSubview(vStack)

        vStack.addArrangedSubview(ruNameLabel)
        vStack.addArrangedSubview(engNameLabel)
        vStack.addArrangedSubview(descriptionLabel)

        setupConstraints()
        isSkeletonable = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            animeImageView.heightAnchor.constraint(equalTo: hStack.heightAnchor),
            animeImageView.widthAnchor.constraint(equalTo: animeImageView.heightAnchor, multiplier: 350 / 500)
        ])
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct SearchResultsTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            SearchResultsTableViewCell()
        }
        .frame(width: 390, height: 100)
    }
}

#endif