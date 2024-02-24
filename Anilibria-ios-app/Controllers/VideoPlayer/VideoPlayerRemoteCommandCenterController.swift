//
//  VideoPlayerRemoteCommandCenterController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.11.2023.
//

import Foundation
import MediaPlayer

final class VideoPlayerRemoteCommandCenterController: NSObject {
    private weak var videoPlayerController: VideoPlayerController?
    
    func setup(with videoPlayerController: VideoPlayerController) {
        self.videoPlayerController = videoPlayerController
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget(self, action: #selector(playCommand(_:)))
        commandCenter.pauseCommand.addTarget(self, action: #selector(pauseCommand(_:)))
        
        let skipSeconds: NSNumber = 10
        commandCenter.skipForwardCommand.preferredIntervals = [skipSeconds]
        commandCenter.skipForwardCommand.addTarget(self, action: #selector(skipForwardCommand(_:)))
        
        commandCenter.skipBackwardCommand.preferredIntervals = [skipSeconds]
        commandCenter.skipBackwardCommand.addTarget(self, action: #selector(skipBackwardCommand(_:)))
        
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPositionCommand(_:)))
    }
}

// MARK: - Private methods

private extension VideoPlayerRemoteCommandCenterController {
    @objc func playCommand(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        videoPlayerController?.customView.middleView.playPauseButton(isSelected: true)
        let player = videoPlayerController?.customView.playerView.player
        player?.play()
        return .success
    }
    
    @objc func pauseCommand(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        videoPlayerController?.customView.middleView.playPauseButton(isSelected: false)
        let player = videoPlayerController?.customView.playerView.player
        player?.pause()
        return .success
    }
    
    @objc func skipForwardCommand(_ event: MPSkipIntervalCommandEvent) -> MPRemoteCommandHandlerStatus {
        videoPlayerController?.forwardButtonDidTapped()
        return .success
    }
    
    @objc func skipBackwardCommand(_ event: MPSkipIntervalCommandEvent) -> MPRemoteCommandHandlerStatus {
        videoPlayerController?.backwardButtonDidTapped()
        return .success
    }
    
    @objc func changePlaybackPositionCommand(_ event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        videoPlayerController?.configurePlayerTime(time: Float(event.positionTime))
        let time = CMTimeMake(value: Int64(event.positionTime), timescale: 1)
        let player = videoPlayerController?.customView.playerView.player
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        return .success
    }
}
