//
//  SearchResultsTableFooterView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 11.03.2023.
//

import UIKit

final class SearchResultsTableFooterView: UIView {
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.addSubview(activityIndicatorView)
        
        self.frame.size.height = activityIndicatorView.frame.height + 4 * 2
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
