//
//  VideoPlayerItem.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 06.12.2023.
//

import Foundation

enum PlayerSettingsRow: Int, CaseIterable, CustomStringConvertible {
    case quality
    case rate
    case ambientMode
    
    var description: String {
        switch self {
            case .quality:
                return Strings.VideoPlayerSettings.quality
            case .rate:
                return Strings.VideoPlayerSettings.rate
            case .ambientMode:
                return Strings.VideoPlayerSettings.ambientMode
        }
    }
}

enum PlayerRate: Float, CustomStringConvertible, CaseIterable {
    /// 0.25
    case lowOne = 0.25
    /// 0.5
    case lowTwo = 0.5
    /// 0.75
    case lowThree = 0.75
    /// 1.0
    case `default` = 1.0
    /// 1.25
    case hightOne = 1.25
    /// 1.5
    case hightTwo = 1.5
    /// 1.75
    case hightThree = 1.75
    /// 2.0
    case hightFour = 2.0
    
    var description: String {
        switch self {
            case .default:
                return Strings.VideoPlayerSettings.defaultRate
            default:
                return String(self.rawValue)
        }
    }
}
