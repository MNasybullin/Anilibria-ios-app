//
//  HapticEngineService.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 22.05.2024.
//

import CoreHaptics
import AVFoundation
import OSLog

final class HapticEngineService {
    private var engine: CHHapticEngine?
    private let logger = Logger(subsystem: .hapticEngine, category: .empty)
    
    lazy var supportsHaptics: Bool = {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        return hapticCapability.supportsHaptics
    }()
    
    enum Patterns: String {
        case favoritesButton = "FavoritesButtonHaptic"
    }
    
    init() {
        createEngine()
    }
    
    private func createEngine() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch {
            logger.error("Engine Creation Error: \(Logger.logInfo(error: error)).")
        }
        
        guard let engine = engine else {
            logger.debug("Failed to create engine!")
            return
        }
        
        configureStoppedHandler(engine)
        configureResetHandler(engine)
    }
    
    private func configureStoppedHandler(_ engine: CHHapticEngine) {
        engine.stoppedHandler = { [weak self] reason in
            var reasonDescription: String
            switch reason {
                case .audioSessionInterrupt:
                    reasonDescription = "Audio session interrupt"
                case .applicationSuspended:
                    reasonDescription = "Application suspended"
                case .idleTimeout:
                    reasonDescription = "Idle timeout"
                case .systemError:
                    reasonDescription = "System error"
                case .notifyWhenFinished:
                    reasonDescription = "Playback finished"
                case .gameControllerDisconnect:
                    reasonDescription = "Controller disconnected."
                case .engineDestroyed:
                    reasonDescription = "Engine destroyed."
                @unknown default:
                    reasonDescription = "Unknown error"
            }
            self?.logger.debug("The engine stopped for reason: \(reason.rawValue). Reason Description: \(reasonDescription).")
        }
    }
    
    private func configureResetHandler(_ engine: CHHapticEngine) {
        engine.resetHandler = { [weak self] in
            self?.logger.debug("The engine reset --> Restarting now!")
            do {
                try self?.engine?.start()
            } catch {
                self?.logger.error("Failed to restart the engine: \(Logger.logInfo(error: error)).")
            }
        }
    }
    
    func playHapticsPattern(_ pattern: Patterns) {
        if !supportsHaptics {
            return
        }
        
        guard let path = Bundle.main.path(forResource: pattern.rawValue, ofType: "ahap") else {
            logger.error("Pattern file \(pattern.rawValue).ahap not found.")
            return
        }
        
        do {
            try engine?.start()
            try engine?.playPattern(from: URL(fileURLWithPath: path))
        } catch {
            logger.error("An error occured playing \(pattern.rawValue): \(Logger.logInfo(error: error)).")
        }
    }
}
