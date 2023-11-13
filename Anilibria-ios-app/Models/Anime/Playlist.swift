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
    init(fromGTPlaylist gtPlaylist: GTPlaylist) {
        self.init(
            serie: gtPlaylist.serie,
            serieString: Playlist.getSerieString(from: gtPlaylist.serie),
            createdTimestamp: gtPlaylist.createdTimestamp,
            createdDateString: Playlist.getCreatedDateString(from: gtPlaylist.createdTimestamp),
            preview: gtPlaylist.preview ?? "",
            skips: gtPlaylist.skips,
            hls: Playlist.getHLS(from: gtPlaylist.hls)
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
    
    private static func getHLS(from gtHLS: GTHls) -> [HLS] {
        var hls = [HLS]()
        if let fullhd = gtHLS.fhd {
            hls.append(.fullHD(fullhd))
        }
        if let hd = gtHLS.hd {
            hls.append(.hd(hd))
        }
        if let sd = gtHLS.sd {
            hls.append(.sd(sd))
        }
        return hls
    }
}
