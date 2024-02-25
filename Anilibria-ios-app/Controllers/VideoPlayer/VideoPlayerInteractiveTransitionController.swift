//
//  VideoPlayerInteractiveTransitionController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 23.02.2024.
//

import UIKit

// swiftlint: disable type_name
final class VideoPlayerInteractiveTransitionController: UIPercentDrivenInteractiveTransition {
    private weak var videoPlayerVC: VideoPlayerController!
    var interactionInProgress = false
    
    init(viewController: VideoPlayerController) {
        self.videoPlayerVC = viewController
        super.init()
        videoPlayerVC.transitioningDelegate = self
        prepareGestureRecognizer(in: videoPlayerVC.view)
    }
}

private extension VideoPlayerInteractiveTransitionController {
    func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch gestureRecognizer.state {
            case .began:
                guard velocity.y > 0 else { break }
                interactionInProgress = true
                videoPlayerVC.dismiss(animated: true)
            case .changed:
                update(progress)
                if interactionInProgress {
                    videoPlayerVC.view.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
                    let volume = Float(1 - progress) / 2
                    videoPlayerVC.customView.playerView.player?.volume = volume <= 0 ? 0.05 : volume
                }
            case .cancelled:
                interactionInProgress = false
                cancel()
            case .ended:
                interactionInProgress = false
                if progress > 0.7 || (velocity.y > 300 && progress > 0.2) {
                    videoPlayerVC.willDismiss()
                    finish()
                } else {
                    cancel()
                }
            default:
                break
        }
    }
}

extension VideoPlayerInteractiveTransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        interactionInProgress ? VideoPlayerDismissAnimator() : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionInProgress ? self : nil
    }
}
