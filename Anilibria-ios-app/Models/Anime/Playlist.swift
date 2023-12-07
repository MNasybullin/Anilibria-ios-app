//
//  Playlist.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.11.2023.
//

import UIKit

struct Playlist {
    let serie: Double?
    let serieString: String
    let createdTimestamp: Int?
    let createdDateString: String
    let preview: String
    var image: UIImage?
    let skips: GTSkips
    let hls: [HLS]
}

extension Playlist {
    init(fromGTPlaylist item: GTPlaylist) {
        self.init(
            serie: item.serie,
            serieString: Playlist.getSerieString(from: item.serie),
            createdTimestamp: item.createdTimestamp,
            createdDateString: Playlist.getCreatedDateString(from: item.createdTimestamp),
            preview: item.preview ?? "",
            skips: item.skips,
            hls: Playlist.getHlsArray(from: item.hls)
        )
    }
    
    private static func getSerieString(from serie: Double?) -> String {
        var serieString = ""
        if serie != nil {
            let int = Int(exactly: serie!)
            let numberString: String = int == nil ? serie!.description : int!.description
            serieString = numberString + " " + "серия"
        }
        return serieString
    }
    
    private static func getCreatedDateString(from createdTimestamp: Int?) -> String {
        var createdDateString = ""
        if let timestamp = createdTimestamp {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            createdDateString = date.formatted(date: .long, time: .omitted)
        }
        return createdDateString
    }
    
    private static func getHlsArray(from gtHls: GTHls) -> [HLS] {
        var array: [HLS] = []
        if let fhdQuality = gtHls.fhd {
            array.append(.fhd(url: fhdQuality))
        }
        if let hdQuality = gtHls.hd {
            array.append(.hd(url: hdQuality))
        }
        if let sdQuality = gtHls.sd {
            array.append(.sd(url: sdQuality))
        }
        return array
    }
}
