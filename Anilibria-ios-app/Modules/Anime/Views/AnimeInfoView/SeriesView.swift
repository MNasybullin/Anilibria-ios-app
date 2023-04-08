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
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Серии"
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
        config.title = "Все"
        config.contentInsets.trailing = 0
        config.baseForegroundColor = .systemRed
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(hStack)
        
        setupTapGR()
        setupHStack()
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
    }
    
    private func setupTapGR() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGR)
    }
    
    @objc private func viewTapped() {
        delegate?.viewClicked()
    }
    
    private func setupHStack() {
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(allButton)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
