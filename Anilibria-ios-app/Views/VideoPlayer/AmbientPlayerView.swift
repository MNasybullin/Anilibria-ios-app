//
//  AmbientPlayerView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 24.02.2024.
//

import UIKit

final class AmbientPlayerView: PlayerView {
    private let userDefaults = UserDefaults.standard
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        updateStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        playerLayer.videoGravity = .resize
        
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
    }
    
    func updateStatus() {
        isHidden = !userDefaults.ambientMode
    }
}
