//
//  SettingsAppearanceCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 18.02.2024.
//

import UIKit

final class SettingsAppearanceCell: UICollectionViewCell {
    typealias Localization = Strings.SettingsModule.Appearance
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension SettingsAppearanceCell {
    func setupView() {
        layer.borderColor = UIColor.systemRed.cgColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Internal methods

extension SettingsAppearanceCell {
    func configureView(style: SettingsContentController.AppearanceStyle) {
        configureViewForIsSelected()
        switch style {
            case .unspecified:
                imageView.image = nil
                titleLabel.text = Localization.Title.unspecified
                subtitleLabel.text = Localization.Subtitle.unspecified
                stackView.alignment = .leading
            case .light:
                imageView.image = UIImage(systemName: "sun.max.fill")
                titleLabel.text = Localization.Title.light
                subtitleLabel.text = nil
                stackView.alignment = .center
            case .dark:
                imageView.image = UIImage(systemName: "moon.fill")
                titleLabel.text = Localization.Title.dark
                subtitleLabel.text = nil
                stackView.alignment = .center
            @unknown default:
                break
        }
    }
    
    func configureViewForIsSelected() {
        backgroundColor = isSelected ? .systemBackground : .secondarySystemBackground
        UIView.animate(withDuration: 0.25) {
            self.titleLabel.textColor = self.isSelected ? .label : .secondaryLabel
            self.layer.borderWidth = self.isSelected ? 1.5 : 0.0
            self.imageView.tintColor = self.isSelected ? .label : .secondaryLabel
        }
    }
}
