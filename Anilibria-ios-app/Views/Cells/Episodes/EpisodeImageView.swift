//
//  EpisodeImageView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.01.2024.
//

import UIKit

final class EpisodeImageView: UIImageView {
    private lazy var watchingProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemRed
        progressView.trackTintColor = .systemGray.withAlphaComponent(0.5)
        progressView.progressViewStyle = .bar
        
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.04),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        return progressView
    }()
    
    var watchingProgressIsHidden: Bool {
        get {
            return watchingProgress.isHidden
        }
        set {
            watchingProgress.isHidden = newValue
        }
    }
    
    func setupWatchingProgress(withDuration duration: Double, playbackTime: Double) {
        watchingProgress.isHidden = false
        let progress = playbackTime / duration
        watchingProgress.setProgress(Float(progress), animated: false)
    }
}
