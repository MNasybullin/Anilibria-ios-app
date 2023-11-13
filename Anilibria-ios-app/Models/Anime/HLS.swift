//
//  HLS.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.11.2023.
//

import Foundation

enum HLS {
    case fullHD(String)
    case hd(String)
    case sd(String)
}

extension HLS: CustomStringConvertible {
    var description: String {
        switch self {
            case .fullHD:
                return "1080p"
            case .hd:
                return "720p"
            case .sd:
                return "480p"
        }
    }
}
