//
//  HLS.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 07.12.2023.
//

import Foundation

enum HLS {
    case fhd (url: String)
    case hd (url: String)
    case sd (url: String)
    
    var url: String {
        switch self {
            case .fhd(let url):
                return url
            case .hd(let url):
                return url
            case .sd(let url):
                return url
        }
    }
}

extension HLS: CustomStringConvertible {
    var description: String {
        switch self {
            case .fhd:
                return "1080p"
            case .hd:
                return "720p"
            case .sd:
                return "480p"
        }
    }
}
