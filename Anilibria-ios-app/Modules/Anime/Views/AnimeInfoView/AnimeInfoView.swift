//
//  AnimeInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.03.2023.
//

import UIKit

final class AnimeInfoView: UIView {
    
    lazy var mainHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        return stack
    }()
    
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
        addSubview(mainHStack)
        
        setupMainHStack()
        setupContentVStack()
        setupEngNameAndSeasonAndTypeVStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMainHStack() {
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            mainHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        mainHStack.addArrangedSubview(contentVStack)
    }
    
    private func setupContentVStack() {
        contentVStack.addArrangedSubview(ruNameLabel)
        contentVStack.addArrangedSubview(engNameAndSeasonAndTypeVStack)
        contentVStack.addArrangedSubview(watchAndDownloadButtonsView)
        contentVStack.addArrangedSubview(genresLabel)
        contentVStack.addArrangedSubview(favoriteAndShareButtonsView)
        contentVStack.addArrangedSubview(descriptionLabel)
        contentVStack.addArrangedSubview(seriesView)
    }
    
    private func setupEngNameAndSeasonAndTypeVStack() {
        engNameAndSeasonAndTypeVStack.addArrangedSubview(engNameLabel)
        engNameAndSeasonAndTypeVStack.addArrangedSubview(seasonAndTypeLabel)
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
