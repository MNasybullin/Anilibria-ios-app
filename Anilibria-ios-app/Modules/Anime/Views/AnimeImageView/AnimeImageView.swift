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
        
        setupBlurEffect()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: topSafeAreaHeight),
            imageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -bottomHeightAfterImageView),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 350 / 500)
        ])
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
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
