//
//  FavoritesButtonParticleEffectView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.05.2024.
//

import UIKit

final class FavoritesButtonParticleEffectView: UIView {
    private let hapticEngineService = HapticEngineService()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let superview = newSuperview else {
            self.layer.removeAllAnimations()
            return
        }
        
        frame = superview.bounds
        isUserInteractionEnabled = false
    }
}

extension FavoritesButtonParticleEffectView {
    private func commonInit() {
        isUserInteractionEnabled = false
    }
    
    func emit(position: CGPoint, completion: (() -> Void)? = nil) {
        let emitterLayer = createEmitterLayer(position: position)
        self.layer.addSublayer(emitterLayer)
        
        let birthRateValueAnimation = createBirthRateValueAnimation()
        let fadeAnimation = createFadeAnimation()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            emitterLayer.opacity = 0
            emitterLayer.removeAllAnimations()
            emitterLayer.removeFromSuperlayer()
            completion?()
        }
        hapticEngineService.playHapticsPattern(.favoritesButton)
        emitterLayer.add(birthRateValueAnimation, forKey: nil)
        emitterLayer.add(fadeAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    private func createEmitterLayer(position: CGPoint) -> CAEmitterLayer {
        let layer = CAEmitterLayer()
        layer.emitterShape = .point
        layer.emitterSize = CGSize(width: 0.0, height: 0.0)
        layer.emitterPosition = position
        layer.emitterMode = .surface
        layer.renderMode = .additive
        let emitterCell = createEmitterCell()
        layer.emitterCells = [emitterCell]
        layer.frame = self.bounds
        layer.needsDisplayOnBoundsChange = true
        layer.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        return layer
    }
    
    private func createBirthRateValueAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.values = [1, 0, 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func createFadeAnimation() -> CATransition {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 4
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.isRemovedOnCompletion = false
        return transition
    }
    
    private func createEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "heart.fill.png")?.cgImage
        cell.birthRate = 990.0
        cell.lifetime = 5.0
        cell.lifetimeRange = 1.0
        cell.velocity = 95.0
        cell.velocityRange = 490.0
        cell.xAcceleration = 0
        cell.yAcceleration = 220.0
        cell.emissionLatitude = CGFloat(Float.random(in: 0...360) * (.pi / 180.0))
        cell.emissionLongitude = CGFloat(Float.random(in: 0...360) * (.pi / 180.0))
        cell.emissionRange = 360.0 * (.pi / 180.0)
        cell.spin = 65.0 * (.pi / 180.0)
        cell.spinRange = 314.0 * (.pi / 180.0)
        cell.scale = 0.5
        cell.scaleSpeed = -0.077
        cell.alphaSpeed = 0.42
        cell.color = UIColor(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        cell.redRange = 0.3
        cell.greenRange = 0.21
        cell.blueRange = 0.6
        return cell
    }
}
