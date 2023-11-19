//
//  SearchResultsHeaderView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 15.03.2023.
//

import UIKit

final class SearchResultsHeaderView: UIView {
    private enum Constants {
        static let titleLabelFontSize: CGFloat = 17
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.SearchModule.HeaderView.notFound
        label.font = UIFont.systemFont(
            ofSize: Constants.titleLabelFontSize,
            weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SearchResultsHeaderView {
    func configureLayout() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
