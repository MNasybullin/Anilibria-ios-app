//
//  HomeHeaderSupplementaryView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.10.2023.
//

import UIKit

final class HomeHeaderSupplementaryView: UICollectionReusableView {
    private enum Constants {
        static let stackViewSpacing: CGFloat = 6
        static let labelFontSize: CGFloat = 24
        static let buttonFontSize: CGFloat = 18
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize, 
                                       weight: .semibold)
        return label
    }()
    
    private lazy var titleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemRed
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: Constants.buttonFontSize, 
                                              weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)

        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleButton.configuration?.title = nil
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        titleButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

// MARK: - Internal methods

extension HomeHeaderSupplementaryView {
    func configureView(titleLabelText: String?, titleButtonText: String?) {
        titleLabel.text = titleLabelText
        if titleLabelText != nil {
            titleButton.setTitle(titleButtonText, for: .normal)
            titleButton.isEnabled = true
        }
    }
    
    func addButtonTarget(_ target: Any?, action: Selector) {
        titleButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
