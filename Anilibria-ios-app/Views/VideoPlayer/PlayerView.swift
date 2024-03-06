//
//  PlayerView.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.11.2023.
//

import UIKit
import AVKit

class PlayerView: UIView {
    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer {
        guard let playerLayer = layer as? AVPlayerLayer else {
            fatalError("AssetPlayerView player layer must be an AVPlayerLayer")
        }
        return playerLayer
    }
}
