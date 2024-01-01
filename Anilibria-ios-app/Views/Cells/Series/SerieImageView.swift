//
//  SerieImageView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.01.2024.
//

import UIKit

final class SerieImageView: UIImageView {
    private lazy var watchingProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemRed
        progressView.trackTintColor = .systemGray
        
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
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
