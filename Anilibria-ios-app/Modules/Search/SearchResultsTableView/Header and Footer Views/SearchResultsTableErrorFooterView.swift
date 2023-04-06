//
//  SearchResultsTableErrorFooterView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.03.2023.
//

import UIKit

protocol SearchResultsTableErrorFooterViewDelegate: AnyObject {
    func refreshButtonClicked()
}

final class SearchResultsTableErrorFooterView: UIView {
    var delegate: SearchResultsTableErrorFooterViewDelegate?
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = Strings.SearchModule.ErrorFooterView.refreshButton
        config.baseForegroundColor = .systemRed
        config.buttonSize = .medium
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.refreshButtonClicked()
        }, for: .touchUpInside)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubview(vStack)
        vStack.addArrangedSubview(title)
        vStack.addArrangedSubview(refreshButton)
        let border: CGFloat = 18

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: border),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: border),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -border),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -border)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
