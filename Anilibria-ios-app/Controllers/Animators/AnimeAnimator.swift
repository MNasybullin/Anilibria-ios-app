//
//  AnimeAnimator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.01.2024.
//

// swiftlint: disable function_body_length

import UIKit

protocol HasPosterCellAnimatedTransitioning: AnyObject {
    var selectedCell: PosterCollectionViewCell? { get }
    var selectedCellImageViewSnapshot: UIView? { get }
}

final class AnimeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 0.25
    
    private let isPresenting: Bool
    
    private let cellController: UIViewController
    private let animeController: AnimeController
    private let selectedCell: PosterCollectionViewCell
    private var selectedCellImageViewSnapshot: UIView
    private let selectedCellImageViewRect: CGRect
    private let window: UIWindow
    let interactionController: PopSwipeInteractiveTransitionController?
    
    init?(type: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) {
        self.isPresenting = type == .push
        
        if type == .push {
            guard let animeController = toVC as? AnimeController else {
                return nil
            }
            self.cellController = fromVC
            self.animeController = animeController
        } else {
            guard let animeController = fromVC as? AnimeController else {
                return nil
            }
            self.cellController = toVC
            self.animeController = animeController
        }
        
        guard let posterCellProtocol = cellController as? HasPosterCellAnimatedTransitioning,
            let selectedCell = posterCellProtocol.selectedCell,
              let selectedCellImageViewSnapshot = posterCellProtocol.selectedCellImageViewSnapshot,
              let window = cellController.view.window ?? animeController.view.window else {
            return nil
        }
        self.selectedCell = selectedCell
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        self.selectedCellImageViewRect = selectedCell.imageView.convert(selectedCell.imageView.bounds, to: window)
        self.window = window
        self.interactionController = animeController.interactiveTransitionController
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from),
              let toViewSnapshot = toView.snapshotView(afterScreenUpdates: true),
              let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        containerView.insertSubview(toView, belowSubview: fromView)
        if isPresenting {
            toView.layoutIfNeeded()
        }
        
        guard let controllerImageViewSnapshot = animeController.customView.animeImageView.imageView.snapshotView(afterScreenUpdates: true),
              let controllerImage = animeController.customView.animeImageView.imageView.image,
              let windowViewSnapshot = window.snapshotView(afterScreenUpdates: false),
              let controllerBackgroundImageViewSnapshot = animeController.customView.animeImageView.backgroundImageView.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(true)
            return
        }
        
        // MARK: - Background Start
        let removeCellView = UIView(frame: selectedCellImageViewRect)
        removeCellView.backgroundColor = cellController.view.backgroundColor
        let controllerBackgroundImageViewRect = animeController.customView.animeImageView.backgroundImageView.convert(animeController.customView.animeImageView.backgroundImageView.bounds, to: window)
        controllerBackgroundImageViewSnapshot.frame = controllerBackgroundImageViewRect
        
        let backgroundView = isPresenting ? windowViewSnapshot : toViewSnapshot
        backgroundView.addSubview(removeCellView)
        
        let fadeView = isPresenting ? toViewSnapshot : fromViewSnapshot
        fadeView.addSubview(controllerBackgroundImageViewSnapshot)
        fadeView.alpha = isPresenting ? 0 : 1
        // MARK: - Background Finish
        
        // MARK: - PosterImageView Start
        let posterImageView = isPresenting ? controllerImageViewSnapshot : UIImageView(image: controllerImage)
        let controllerImageViewRect = animeController.customView.animeImageView.imageView.convert(animeController.customView.animeImageView.imageView.bounds, to: window)
        
        [selectedCellImageViewSnapshot, posterImageView].forEach {
            $0.frame = isPresenting ? selectedCellImageViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? PosterCollectionViewCell.Constants.imageViewCornerRadius : 0
            $0.layer.masksToBounds = true
        }
        
        let swapImage: Bool = selectedCell.imageView.image != animeController.customView.animeImageView.imageView.image
        
        if swapImage {
            self.selectedCellImageViewSnapshot.alpha = self.isPresenting ? 1 : 0
            posterImageView.alpha = self.isPresenting ? 0 : 1
        } else {
            self.selectedCellImageViewSnapshot.alpha = 0
            posterImageView.alpha = 1
        }
        // MARK: - PosterImageView Image Finish
        
        [backgroundView, fadeView, selectedCellImageViewSnapshot, posterImageView].forEach {
            containerView.addSubview($0)
        }
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: [.calculationModeCubic]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
                [self.selectedCellImageViewSnapshot, posterImageView].forEach {
                    $0.frame = self.isPresenting ? controllerImageViewRect : self.selectedCellImageViewRect
                    $0.layer.cornerRadius = self.isPresenting ? 0 : PosterCollectionViewCell.Constants.imageViewCornerRadius
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                fadeView.alpha = self.isPresenting ? 1 : 0
            }
            if swapImage {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                    self.selectedCellImageViewSnapshot.alpha = self.isPresenting ? 0 : 1
                    posterImageView.alpha = self.isPresenting ? 1 : 0
                }
            }
        } completion: { _ in
            posterImageView.removeFromSuperview()
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            fadeView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
