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
        imageView.image = UIImage(asset: Asset.Assets.blankImage)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: Asset.Assets.blankImage)
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    lazy var topSafeAreaHeight: CGFloat = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.safeAreaInsets.top ?? 0.0
    }()
    
    var bottomHeightAfterImageView: CGFloat = 40
    
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundImageView)
        addSubview(imageView)
        
        setupBackgroundImageViewConstraints()
        setupBlurEffect()
        setupImageViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }
    
    private func setupBackgroundImageViewConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: topSafeAreaHeight),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: backgroundImageView.heightAnchor, constant: -topSafeAreaHeight - bottomHeightAfterImageView),
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
            AnimeImageView()
        }
        .frame(height: 500)
    }
}

#endif
