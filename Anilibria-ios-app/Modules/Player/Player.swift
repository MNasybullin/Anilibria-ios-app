//
//  Player.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 09.04.2023.
//

import UIKit
import AVFoundation
import AVKit

final class Player {
    static func playVideo(url: URL, viewController: UIViewController) {
        let player = AVPlayer(url: url)

        let controller = AVPlayerViewController()
        controller.player = player

        viewController.present(controller, animated: true) {
            player.play()
        }
    }
}
