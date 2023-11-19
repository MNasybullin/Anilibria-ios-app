//
//  SearchResultsErrorFooterView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.03.2023.
//

import UIKit

protocol SearchResultsErrorFooterViewDelegate: AnyObject {
    func refreshButtonClicked()
}

final class SearchResultsErrorFooterView: UIView {
    private enum Constants {
        static let stackSpacing: CGFloat = 8
        static let titleLabelFontSize: CGFloat = 17
        static let titleLabelNumberOfLines: Int = 0
    }
    
    var delegate: SearchResultsErrorFooterViewDelegate?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constants.stackSpacing
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.SearchModule.ErrorFooterView.titleLabel
        label.font = UIFont.systemFont(
            ofSize: Constants.titleLabelFontSize,
            weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = Constants.titleLabelNumberOfLines
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SearchResultsErrorFooterView {
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(refreshButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
