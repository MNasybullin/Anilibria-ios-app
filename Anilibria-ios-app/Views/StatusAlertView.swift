//
//  StatusAlertView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 23.01.2024.
//

import UIKit

class StatusAlertView: UIView {
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        setupStackView()
        setupImageView()
        setupTitleLabel()
        setupMessageLabel()
        setupActionButton()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension StatusAlertView {
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
    }
    
    func setupMessageLabel() {
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 4
        messageLabel.textAlignment = .center
    }
    
    func setupActionButton() {
        let config = UIButton.Configuration.plain()
        actionButton.configuration = config
        actionButton.tintColor = .systemRed
    }
    
    func setupLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView, titleLabel, messageLabel, actionButton].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
            
        ])
    }
}

// MARK: - Configuration

extension StatusAlertView {
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setTitle(text: String?) {
        titleLabel.text = text
    }
    
    func setMessage(text: String?) {
        messageLabel.text = text
    }
    
    func setActionButton(title: String?, for state: UIControl.State) {
        actionButton.setTitle(title, for: state)
    }
    
    func setActionButton(action: UIAction, for event: UIControl.Event) {
        actionButton.addAction(action, for: event)
    }
    
    var actionButtonIsHidden: Bool {
        get { actionButton.isHidden }
        set { actionButton.isHidden = newValue }
    }
    
    func setupFullScreenConstraints(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
