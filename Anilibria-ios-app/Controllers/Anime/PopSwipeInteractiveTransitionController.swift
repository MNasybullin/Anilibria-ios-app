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
        view.addGestureRecognizer(gesture)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            case .began:
                interactionInProgress = true
                viewController.navigationController?.popViewController(animated: true)
            case .changed:
                update(progress)
            case .cancelled:
                interactionInProgress = false
                cancel()
            case .ended:
                interactionInProgress = false
                if progress > 0.5 {
                    finish()
                } else {
                    cancel()
                }
            default:
                break
        }
    }
}
