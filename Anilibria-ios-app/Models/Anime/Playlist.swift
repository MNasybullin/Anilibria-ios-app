//
//  Playlist.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.11.2023.
//

import UIKit

struct Playlist {
    let episode: Float?
    let name: String?
    let uuid: String?
    let episodeString: String
    let createdTimestamp: Int?
    let createdDateString: String
    let previewUrl: String
    var image: UIImage?
    let skips: GTSkips
    let hls: [HLS]
}

extension Playlist {
    init(fromGTPlaylist item: GTPlaylist) {
        self.init(
            episode: item.episode,
            name: item.name,
            uuid: item.uuid,
            episodeString: Playlist.getEpisodeString(from: item.episode),
            createdTimestamp: item.createdTimestamp,
            createdDateString: Playlist.getCreatedDateString(from: item.createdTimestamp),
            previewUrl: Playlist.getPreviewUrl(fromPreview: item.preview),
            skips: item.skips,
            hls: Playlist.getHlsArray(from: item.hls)
        )
    }
    
    private static func getEpisodeString(from episode: Float?) -> String {
        var episodeString = ""
        if episode != nil {
            let int = Int(exactly: episode!)
            let numberString: String = int == nil ? episode!.description : int!.description
            episodeString = numberString + " " + "серия"
        }
        return episodeString
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
    
    private static func getPreviewUrl(fromPreview preview: String?) -> String {
        guard let preview else {
            return ""
        }
        return AppRemoteConfig.shared.string(forKey: .mirrorBaseImagesURL) + preview
    }
}
