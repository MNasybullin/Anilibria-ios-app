//
//  AnimeTeamInfoView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 08.12.2023.
//

import UIKit

final class AnimeTeamInfoView: UIView {
    private lazy var vStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureView(withData teams: [Team]) {
        teams.forEach { team in
            let label = UILabel()
            label.font = .systemFont(ofSize: 15)
            label.numberOfLines = 0
            
            let originalText = team.description + ": " + team.nicknames.joined(separator: ", ")
            let attributedString = NSMutableAttributedString(string: originalText)
            if let range = originalText.range(of: team.description + ": ") {
                let nsRange = NSRange(range, in: originalText)

                attributedString.addAttribute(
                    .font,
                    value: UIFont.systemFont(ofSize: 16, weight: .bold),
                    range: nsRange
                )
            }
            label.attributedText = attributedString
            vStack.addArrangedSubview(label)
        }
    }
}
