//
//  HomeHeaderSupplementaryView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 19.10.2023.
//

import UIKit
import SkeletonView

final class HomeHeaderSupplementaryView: UICollectionReusableView {
    enum Constants {
        static let stackViewSpacing: CGFloat = 6
        static let titleFont: UIFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let layoutConstants: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: -8, trailing: -8)
        static let buttonFontSize: CGFloat = 18
        static let linesCornerRadius: Int = 5
        static let skeletonCornerRadius: Float = 5
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        stackView.isSkeletonable = true
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.isSkeletonable = true
        label.linesCornerRadius = Constants.linesCornerRadius
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
        
        button.addAction(UIAction(handler: { _ in
            self.buttonDidTappedCallback?()
        }), for: .touchUpInside)
        
        button.isSkeletonable = true
        button.skeletonCornerRadius = Constants.skeletonCornerRadius
        return button
    }()
    
    private var buttonDidTappedCallback: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleButton.isEnabled = true
    }
    
    private func configureView() {
        backgroundColor = .systemBackground
        isSkeletonable = true
    }
    
    private func configureLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.layoutConstants.leading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.layoutConstants.trailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.layoutConstants.bottom)
        ])

        titleButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

// MARK: - Internal methods

extension HomeHeaderSupplementaryView {
    func configureView(titleLabelText: String?, titleButtonText: String? = nil, buttonCallback: (() -> Void)? = nil) {
        titleLabel.text = titleLabelText
        if titleButtonText != nil {
            titleButton.isHidden = false
            titleButton.setTitle(titleButtonText, for: .normal)
            buttonDidTappedCallback = buttonCallback
        } else {
            titleButton.isHidden = true
        }
    }
    
    func titleButton(isEnabled: Bool) {
        titleButton.isEnabled = isEnabled
    }
}
