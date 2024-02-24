//
//  VideoPlayerDismissAnimator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 21.02.2024.
//

import UIKit

// swiftlint: disable function_body_length

final class VideoPlayerDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 0.25
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from),
              let playerVC = transitionContext.viewController(forKey: .from) as? VideoPlayerController,
              let initialVolume = playerVC.customView.playerView.player?.volume else {
            transitionContext.completeTransition(false)
            return
        }
        containerView.insertSubview(toView, belowSubview: fromView)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let orientation = windowScene.interfaceOrientation
            if orientation != .portrait {
                toView.alpha = 0
            }
        }
        
        let videoPlayerView = playerVC.customView
        let overlayStatus = videoPlayerView.isOverlaysHidden
        if overlayStatus == false {
            UIView.performWithoutAnimation {
                videoPlayerView.hideOverlay()
            }
        }
        
        videoPlayerView.ambientPlayerView.alpha = 0
        
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .black
        containerView.insertSubview(fadeView, belowSubview: fromView)
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: [.calculationModeCubic]) {
            
            fromView.backgroundColor = .clear
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8) {
                fadeView.backgroundColor = .clear
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 1) {
                fromView.alpha = 0.5
            }
        } completion: { _ in
            let duration = transitionContext.transitionWasCancelled ? 0.25 : 0
            UIView.animate(withDuration: duration) {
                videoPlayerView.playerView.player?.volume = initialVolume
                fromView.transform = .identity
                videoPlayerView.ambientPlayerView.alpha = 1
            } completion: { _ in
                fadeView.removeFromSuperview()
            }
            toView.alpha = 1
            
            if overlayStatus == false {
                videoPlayerView.showOverlay()
            } else {
                videoPlayerView.hideOverlay()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
