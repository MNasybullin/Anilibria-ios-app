//
//  AnimeInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.03.2023.
//

import UIKit

final class AnimeInfoView: UIView {
    private lazy var contentVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        return stack
    }()
    
    private (set) lazy var ruNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var engNameAndSeasonAndTypeVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var engNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var seasonAndTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private (set) lazy var watchAndDownloadButtonsView = WatchAndDownloadButtonsView()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private (set) lazy var favoriteAndShareButtonsView = FavoriteAndShareButtonsView()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.textAlignment = .natural
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var animeTeamInfoView = AnimeTeamInfoView()
    private (set) lazy var animeEpisodesView = AnimeEpisodesView()
    
    init() {
        super.init(frame: .zero)
        addSubview(contentVStack)
        
        [ruNameLabel, engNameAndSeasonAndTypeVStack, watchAndDownloadButtonsView,
         genresLabel, favoriteAndShareButtonsView, descriptionLabel, animeTeamInfoView,
         animeEpisodesView]
            .forEach { contentVStack.addArrangedSubview($0) }
        
        [engNameLabel, seasonAndTypeLabel].forEach {
            engNameAndSeasonAndTypeVStack.addArrangedSubview($0)
        }
        
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
    
    func configureView(item: AnimeItem) {
        ruNameLabel.text = item.ruName
        engNameLabel.text = item.engName
        seasonAndTypeLabel.text = item.seasonAndType
        genresLabel.text = item.genres
        descriptionLabel.text = item.description
        animeTeamInfoView.configureView(withData: item.team)
        
        let subtitleText = (item.episodes?.string ?? "") + " " + "серий"
        animeEpisodesView.setSubtitle(text: subtitleText)
    }
}
