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
        stack.alignment = .center
        return stack
    }()
    
    lazy var ruNameTitle: UILabel = {
        let label = UILabel()
        label.text = "Песнь ночных сов"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var engNameTitle: UILabel = {
        let label = UILabel()
        label.text = "Yofukashi no Uta"
        return label
    }()
    
    lazy var seasonTitle: UILabel = {
        let label = UILabel()
        label.text = "2022 лето"
        return label
    }()
    
    lazy var typeTitle: UILabel = {
        let label = UILabel()
        label.text = "ТВ (13 эп.), 24 мин."
        return label
    }()
    
    lazy var watchAndDownloadHStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .bottom
        return stack
    }()
    
    lazy var watchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Смотреть", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        return button
    }()
    
    lazy var genresTitle: UILabel = {
        let label = UILabel()
        label.text = "Вампиры, Романтика, Сверхъестественное, Сёнен"
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(mainHStack)
        
        configureMainHStack()
        configureContentVStack()
        configureWatchAndDownloadHStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMainHStack() {
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        mainHStack.addArrangedSubview(contentVStack)
    }
    
    private func configureContentVStack() {
        contentVStack.addArrangedSubview(ruNameTitle)
        contentVStack.addArrangedSubview(engNameTitle)
        contentVStack.addArrangedSubview(seasonTitle)
        contentVStack.addArrangedSubview(typeTitle)
        contentVStack.addArrangedSubview(watchAndDownloadHStack)
        contentVStack.addArrangedSubview(genresTitle)
    }
    
    private func configureWatchAndDownloadHStack() {
        NSLayoutConstraint.activate([
            watchAndDownloadHStack.heightAnchor.constraint(equalToConstant: 14)
        ])
        watchAndDownloadHStack.addArrangedSubview(watchButton)
        watchAndDownloadHStack.addArrangedSubview(downloadButton)
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
