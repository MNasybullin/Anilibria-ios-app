//
//  AnimeImageView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.03.2023.
//

import UIKit

final class AnimeImageView: UIView {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    let topSafeAreaHeight: CGFloat
    
    init(topSafeAreaHeight: CGFloat) {
        self.topSafeAreaHeight = topSafeAreaHeight
        super.init(frame: .zero)
        
        addSubview(backgroundImageView)
        addSubview(imageView)
        
        setupBackgroundImageViewConstraints()
        setupImageViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackgroundImageViewConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 500 / 350)
        ])
    }
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: backgroundImageView.safeAreaLayoutGuide.topAnchor, constant: topSafeAreaHeight + 10),
            imageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -40),
            imageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 350 / 500)
        ])
    }
}

#if DEBUG

// MARK: - Live Preview In UIKit
import SwiftUI
struct AnimeImageView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            AnimeImageView(topSafeAreaHeight: 50)
        }
        .frame(height: 500)
    }
}

#endif
