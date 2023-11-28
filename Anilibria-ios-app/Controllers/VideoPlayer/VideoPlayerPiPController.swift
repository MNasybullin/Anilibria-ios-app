//
//  VideoPlayerPiPController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 23.11.2023.
//

import AVKit
import Combine

final class VideoPlayerPiPController: NSObject {
    
    weak var videoPlayerController: VideoPlayerController?
    private var pipController: AVPictureInPictureController?
    private var subscriptions = Set<AnyCancellable>()
    
    init(videoPlayerController: VideoPlayerController) {
        self.videoPlayerController = videoPlayerController
        super.init()
        setupPiP()
    }
}

// MARK: - Private methods
private extension VideoPlayerPiPController {
    func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported(), let videoPlayerController else {
            videoPlayerController?.customView.setPIPButton(isHidden: true)
            return
        }
        
        pipController = AVPictureInPictureController(playerLayer: videoPlayerController.customView.playerView.playerLayer)
        guard let pipController else {
            return
        }
        pipController.delegate = self
        
        pipController.publisher(for: \.isPictureInPicturePossible)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak videoPlayerController] isPictureInPicturePossible in
                videoPlayerController?.customView.setPIPButton(isHidden: !isPictureInPicturePossible)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Internal methods

extension VideoPlayerPiPController {
    func startPictureInPicture() {
        pipController?.startPictureInPicture()
    }
}

// MARK: - AVPictureInPictureControllerDelegate

extension VideoPlayerPiPController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        videoPlayerController?.customView.hideOverlay()
        videoPlayerController?.navigator?.playerController = videoPlayerController
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        videoPlayerController?.willDismiss()
        videoPlayerController?.dismiss(animated: true)
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        videoPlayerController?.navigator?.playerController = nil
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        videoPlayerController?.navigator?.playerController = nil
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        guard let viewController = videoPlayerController?.navigator?.playerController else {
            completionHandler(false)
            return
        }
        MainNavigator.shared.rootViewController.present(viewController, animated: false) {
            completionHandler(true)
        }
    }
}
