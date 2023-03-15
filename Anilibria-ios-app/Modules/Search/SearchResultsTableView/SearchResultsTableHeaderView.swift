//
//  SearchResultsTableHeaderView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.03.2023.
//

import UIKit

final class SearchResultsTableHeaderView: UIView {
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено :(" // TODO
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubview(headerLabel)
        
        self.frame.size.height = headerLabel.font.lineHeight + 4 * 2
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
