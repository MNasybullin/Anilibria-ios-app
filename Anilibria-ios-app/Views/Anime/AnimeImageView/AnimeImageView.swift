//
//  AnimeImageView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.03.2023.
//

import UIKit

final class AnimeImageView: UIView {
    private (set) lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: Asset.Assets.blankImage)
        return imageView
    }()
    
    private (set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: Asset.Assets.blankImage)
        return imageView
    }()
    
    private lazy var topSafeAreaHeight: CGFloat = {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        return window?.safeAreaInsets.top ?? 0.0
    }()
    
    private var bottomHeightAfterImageView: CGFloat = 40
    
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
    
    func configureView(with image: UIImage?) {
        if image != nil {
            backgroundImageView.image = image
            imageView.image = image
        }
    }
}
