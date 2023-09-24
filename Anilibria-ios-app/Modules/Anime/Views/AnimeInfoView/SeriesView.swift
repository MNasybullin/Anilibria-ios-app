//
//  SeriesView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.04.2023.
//

import UIKit

protocol SeriesViewDelegate: AnyObject {
    func viewClicked()
}

final class SeriesView: UIView {
    weak var delegate: SeriesViewDelegate?
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Серии" // TODO: localizable
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var allButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Все" // TODO: localizable
        config.baseForegroundColor = .systemRed
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGR)
        
        addSubview(hStack)
        
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(allButton)
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    @objc private func viewTapped() {
        delegate?.viewClicked()
    }
    
    private func setupConstraints() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        allButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
