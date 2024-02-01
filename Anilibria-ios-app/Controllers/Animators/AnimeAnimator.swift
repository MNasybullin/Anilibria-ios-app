//
//  AnimeAnimator.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 31.01.2024.
//

import UIKit

final class AnimeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 1.25
    
    private let isPresenting: Bool
    
    private let homeController: HomeController
    private let animeController: AnimeController
    private let selectedCell: PosterCollectionViewCell
    private var selectedCellImageViewSnapshot: UIView
    private let selectedCellImageViewRect: CGRect
    private let window: UIWindow
    
    init?(type: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) {
        self.isPresenting = type == .push
        
        if type == .push {
            guard let homeController = fromVC as? HomeController,
                    let animeController = toVC as? AnimeController else {
                return nil
            }
            self.homeController = homeController
            self.animeController = animeController
        } else {
            guard let animeController = fromVC as? AnimeController,
                    let homeController = toVC as? HomeController else {
                return nil
            }
            self.homeController = homeController
            self.animeController = animeController
        }
        
        guard let selectedCell = homeController.selectedCell,
              let selectedCellImageViewSnapshot = homeController.selectedCellImageViewSnapshot,
              let window = homeController.view.window ?? animeController.view.window else {
            return nil
        }
        self.selectedCell = selectedCell
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        self.selectedCellImageViewRect = selectedCell.imageView.convert(selectedCell.imageView.bounds, to: window)
        self.window = window
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = isPresenting ? animeController.view : homeController.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(toView)
        toView.layoutIfNeeded()
        
        guard let cellImageSnapshot = selectedCell.imageView.snapshotView(afterScreenUpdates: true),
              let controllerImageViewSnapshot = animeController.customView.animeImageView.imageView.snapshotView(afterScreenUpdates: true),
              let homeControllerViewSnapshot = homeController.view.snapshotView(afterScreenUpdates: true),
              let animeControllerViewSnapshot = animeController.view.snapshotView(afterScreenUpdates: true),
              let windowViewSnapshot = window.snapshotView(afterScreenUpdates: false),
              let homeNavViewSnapshot = homeController.navigationViewSnapshot,
              let homeNavBarViewSnapshot = homeController.navBarViewSnapshot,
              let controllerBackgroundImageViewSnapshot = animeController.customView.animeImageView.backgroundImageView.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(true)
            return
        }
        
        let removeCellView = UIView(frame: selectedCellImageViewRect)
        removeCellView.backgroundColor = homeController.view.backgroundColor
        let controllerBackgroundImageViewRect = animeController.customView.animeImageView.backgroundImageView.convert(animeController.customView.animeImageView.backgroundImageView.bounds, to: animeControllerViewSnapshot)
        controllerBackgroundImageViewSnapshot.frame = controllerBackgroundImageViewRect
        
        let backgroundView: UIView
        let fadeView: UIView
        
        if isPresenting {
            let removeCellView = UIView(frame: selectedCellImageViewRect)
            removeCellView.backgroundColor = homeController.view.backgroundColor
            backgroundView = homeNavViewSnapshot
            backgroundView.addSubview(removeCellView)
            fadeView = toView.snapshotView(afterScreenUpdates: true)!
            fadeView.addSubview(controllerBackgroundImageViewSnapshot)
            backgroundView.addSubview(fadeView)
        } else {
            backgroundView = homeNavViewSnapshot
            backgroundView.addSubview(homeNavBarViewSnapshot)
            backgroundView.addSubview(homeControllerViewSnapshot)
            backgroundView.addSubview(removeCellView)
            
            fadeView = animeControllerViewSnapshot
            fadeView.addSubview(controllerBackgroundImageViewSnapshot)
            backgroundView.addSubview(fadeView)
        }
        fadeView.alpha = isPresenting ? 0 : 1
        
        let imageViewSnapshot = controllerImageViewSnapshot
        
        [backgroundView, imageViewSnapshot].forEach { containerView.addSubview($0) }
        
        if animeController.customView.animeImageView.imageView.bounds == .zero {
            animeController.customView.layoutIfNeeded()
        }
        let controllerImageViewRect = animeController.customView.animeImageView.imageView.convert(animeController.customView.animeImageView.imageView.bounds, to: window)
        
        [imageViewSnapshot].forEach {
            $0.frame = isPresenting ? selectedCellImageViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? PosterCollectionViewCell.Constants.imageViewCornerRadius : 0
            $0.layer.masksToBounds = true
        }
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                [imageViewSnapshot].forEach {
                    $0.frame = self.isPresenting ? controllerImageViewRect : self.selectedCellImageViewRect
                    $0.layer.cornerRadius = self.isPresenting ? 0 : PosterCollectionViewCell.Constants.imageViewCornerRadius
                }
                fadeView.alpha = self.isPresenting ? 1 : 0
            }
        } completion: { _ in
            imageViewSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            
//            toView.alpha = 1
            
            transitionContext.completeTransition(true)
        }

    }
}
