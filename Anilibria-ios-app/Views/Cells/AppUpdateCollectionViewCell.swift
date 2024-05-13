//
//  AppUpdateCollectionViewCell.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 16.04.2024.
//

import UIKit

protocol AppUpdateCollectionViewCellDelegate: AnyObject {
    func updateCellHeight()
}

final class AppUpdateCollectionViewCell: UICollectionViewCell {
    enum Constants {
        static let titleFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let appVersionFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let changesFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let subtitleFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    typealias Localization = Strings.AppUpdateCell
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStackView, dividerView, newsLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, headerLabelsStackView])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private lazy var iconImageView: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var headerLabelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, appVersionLabel, changesView])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.title
        label.font = Constants.titleFont
        return label
    }()
    
    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "0.5.0 -> \(AppRemoteConfig.shared.string(forKey: .appVersion))"
        label.font = Constants.appVersionFont
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var changesView = UIView()
    
    private lazy var changesLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.changesFont
        label.text = Localization.whatIsNew
        return label
    }()
    
    private lazy var chevronDownImage = UIImage(systemName: "chevron.down")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    private lazy var chevronUpImage = UIImage(systemName: "chevron.up")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    
    private lazy var changesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = chevronDownImage
        return imageView
    }()
    
    private var changesStackTapped = false
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.isHidden = !changesStackTapped
        return view
    }()
    
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.subtitleFont
        label.numberOfLines = 0
        label.isHidden = !changesStackTapped
        label.text = AppRemoteConfig.shared.string(forKey: .appVersionNews)
        return label
    }()
    
    weak var delegate: AppUpdateCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupChangesView()
        setupLayout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension AppUpdateCollectionViewCell {
    func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    func setupChangesView() {
        changesView.addSubview(changesLabel)
        changesView.addSubview(changesImageView)
    }
    
    func setupLayout() {
        addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 64)
        ])
        
        changesLabel.translatesAutoresizingMaskIntoConstraints = false
        changesImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changesLabel.topAnchor.constraint(equalTo: changesView.topAnchor),
            changesLabel.leadingAnchor.constraint(equalTo: changesView.leadingAnchor),
            changesLabel.bottomAnchor.constraint(equalTo: changesView.bottomAnchor),
            
            changesImageView.trailingAnchor.constraint(equalTo: changesView.trailingAnchor),
            changesImageView.heightAnchor.constraint(equalTo: changesLabel.heightAnchor),
            changesImageView.widthAnchor.constraint(equalTo: changesImageView.heightAnchor)
        ])
    }
    
    func setupGestures() {
        let tapChangesStackGesture = UITapGestureRecognizer(target: self, action: #selector(changesHStackTapped))
        changesView.addGestureRecognizer(tapChangesStackGesture)
        
        let tapNewsLabelGesture = UITapGestureRecognizer(target: self, action: #selector(changesHStackTapped))
        newsLabel.addGestureRecognizer(tapNewsLabelGesture)
    }
    
    @objc func changesHStackTapped() {
        changesStackTapped.toggle()
        UIView.transition(with: changesImageView, duration: 0.5, options: .transitionCrossDissolve) {
            self.changesImageView.image = self.changesStackTapped ? self.chevronUpImage : self.chevronDownImage
        }
        
        UIView.animate(withDuration: 0.5) {
            self.newsLabel.isHidden = !self.changesStackTapped
            self.dividerView.isHidden = !self.changesStackTapped
            self.mainStackView.layoutIfNeeded()
            self.delegate?.updateCellHeight()
        } completion: { _ in
            self.newsLabel.isUserInteractionEnabled = self.changesStackTapped
        }
    }
}

// MARK: - Internal methods

extension AppUpdateCollectionViewCell {
    func configureCell(appVersion: String, news: String) {
        appVersionLabel.text = appVersion
        newsLabel.text = news
    }
}
