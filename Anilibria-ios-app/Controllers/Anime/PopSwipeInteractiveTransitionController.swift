//
//  PopSwipeInteractiveTransitionController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.02.2024.
//

import UIKit

final class PopSwipeInteractiveTransitionController: UIPercentDrivenInteractiveTransition {
    private weak var viewController: UIViewController!
    var interactionInProgress = false
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
}

private extension PopSwipeInteractiveTransitionController {
    func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            case .began:
                guard velocity.x > 0 else { break }
                interactionInProgress = true
                viewController.navigationController?.popViewController(animated: true)
            case .changed:
                update(progress)
            case .cancelled:
                interactionInProgress = false
                cancel()
            case .ended:
                interactionInProgress = false
                if progress > 0.5 || (velocity.x > 0 && progress > 0.2) {
                    finish()
                } else {
                    cancel()
                }
            default:
                break
        }
    }
}
