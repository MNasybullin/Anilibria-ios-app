//
//  YouTubeFooterSupplementaryView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 12.12.2023.
//

import UIKit

protocol YouTubeFooterSupplementaryViewDelegate: AnyObject {
    func didTappedRefreshButton()
}

final class YouTubeFooterSupplementaryView: UICollectionReusableView {
    private enum Constants {
        static let stackSpacing: CGFloat = 8
        static let titleLabelFontSize: CGFloat = 17
    }
    
    var delegate: YouTubeFooterSupplementaryViewDelegate?
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .systemRed
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var errorStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Constants.stackSpacing
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.YouTubeModule.ErrorFooterView.titleLabel
        label.font = UIFont.systemFont(
            ofSize: Constants.titleLabelFontSize,
            weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = Strings.YouTubeModule.ErrorFooterView.refreshButton
        config.baseForegroundColor = .systemRed
        config.buttonSize = .medium
        let button = UIButton(configuration: config)
        
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.didTappedRefreshButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private var commonConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        [errorStackView, activityIndicatorView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        errorStackView.addArrangedSubview(titleLabel)
        errorStackView.addArrangedSubview(refreshButton)
                
        commonConstraints = [
            errorStackView.topAnchor.constraint(equalTo: topAnchor),
            errorStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(commonConstraints)
    }
}

// MARK: - Internal methods

extension YouTubeFooterSupplementaryView {
    func configureView(status: YouTubeView.Status) {
        switch status {
            case .loadingMore:
                NSLayoutConstraint.activate(commonConstraints)
                errorStackView.isHidden = true
                activityIndicatorView.startAnimating()
            case .loadingMoreFail:
                NSLayoutConstraint.activate(commonConstraints)
                activityIndicatorView.stopAnimating()
                errorStackView.isHidden = false
            case .normal:
                NSLayoutConstraint.deactivate(commonConstraints)
                activityIndicatorView.stopAnimating()
                errorStackView.isHidden = true
        }
    }
}
