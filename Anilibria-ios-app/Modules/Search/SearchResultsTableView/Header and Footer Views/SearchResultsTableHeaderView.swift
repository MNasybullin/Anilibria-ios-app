//
//  SearchResultsTableHeaderView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.03.2023.
//

import UIKit

final class SearchResultsTableHeaderView: UIView {
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.SearchModule.HeaderView.notFound
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubview(headerLabel)
        let border: CGFloat = 6
        
        frame.size.height = headerLabel.font.lineHeight + border * 2
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
