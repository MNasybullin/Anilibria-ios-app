//
//  AnimeInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.03.2023.
//

import UIKit

final class AnimeInfoView: UIView {
    
    lazy var contentVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        return stack
    }()
    
    lazy var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var engNameAndSeasonAndTypeVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var seasonAndTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    lazy var watchAndDownloadButtonsView = WatchAndDownloadButtonsView()
    
    lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var favoriteAndShareButtonsView = FavoriteAndShareButtonsView()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.textAlignment = .natural
        label.numberOfLines = 0
        return label
    }()
    
    lazy var seriesView = SeriesView()
    
    init() {
        super.init(frame: .zero)
        addSubview(contentVStack)
        
        contentVStack.addArrangedSubview(ruNameLabel)
        contentVStack.addArrangedSubview(engNameAndSeasonAndTypeVStack)
        contentVStack.addArrangedSubview(watchAndDownloadButtonsView)
        contentVStack.addArrangedSubview(genresLabel)
        contentVStack.addArrangedSubview(favoriteAndShareButtonsView)
        contentVStack.addArrangedSubview(descriptionLabel)
        contentVStack.addArrangedSubview(seriesView)
        
        engNameAndSeasonAndTypeVStack.addArrangedSubview(engNameLabel)
        engNameAndSeasonAndTypeVStack.addArrangedSubview(seasonAndTypeLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentVStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            contentVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct AnimeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            AnimeInfoView()
        }
        .frame(height: 500)
    }
}

#endif
