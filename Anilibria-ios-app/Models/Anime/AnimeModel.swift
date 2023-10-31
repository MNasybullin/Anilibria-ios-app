//
//  AnimeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 29.10.2023.
//

import UIKit

protocol AnimeModelOutput: AnyObject {
    func update(image: UIImage)
}

final class AnimeModel {
    private let rawData: TitleAPIModel
    
    weak var delegate: AnimeModelOutput?
    
    init(rawData: TitleAPIModel) {
        self.rawData = rawData
    }
}

// MARK: - Private methods

private extension AnimeModel {
    func getSeasonAndTypeText() -> String {
        let year = rawData.season?.year?.description == nil ? "" : (rawData.season?.year?.description)! + " "
        let season = rawData.season?.string == nil ? "" : (rawData.season?.string)! + ", "
        let type = rawData.type?.fullString ?? ""
        return year + season + type
    }
    
    func getgenresText() -> String? {
        return rawData.genres?.joined(separator: ", ")
    }
    
    func getDescriptionText() -> String? {
        return rawData.description?.replacingOccurrences(of: "[\r\n]{3,}", with: "\n\n", options: .regularExpression, range: nil)
    }
    
    func getSeries() -> GTSeries? {
        return rawData.player?.series
    }
    
    func getPlaylist() -> [Playlist] {
        var array: [Playlist]?
        array = rawData.player?.playlist?.map {
            Playlist(
                serie: $0.serie,
                serieString: getSerieString(from: $0.serie),
                createdTimestamp: $0.createdTimestamp,
                createdDateString: getCreatedDateString(from: $0.createdTimestamp),
                preview: $0.preview,
                skips: $0.skips,
                hls: $0.hls)
        }
        return array ?? [Playlist]()
    }
    
    func getSerieString(from serie: Double?) -> String {
        var serieString = ""
        if serie != nil {
            let int = Int(exactly: serie!)
            let numberString: String = int == nil ? serie!.description : int!.description
            serieString = numberString + " " + "серия"
        }
        return serieString
    }
    
    func getCreatedDateString(from createdTimestamp: Int?) -> String {
        var createdDateString = ""
        if let timestamp = createdTimestamp {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            createdDateString = date.formatted(date: .long, time: .omitted)
        }
        return createdDateString
    }
}

// MARK: - Internal methods

extension AnimeModel {
    func requestImage() {
        Task {
            do {
                let url = rawData.posters.original.url
                let imageData = try await ImageLoaderService.shared.getImageData(from: url)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                delegate?.update(image: image)
            } catch {
                print(#function, error)
            }
        }
    }
    
    func getAnimeItem() -> AnimeItem {
        requestImage()
        let animeItem = AnimeItem(
            image: nil,
            ruName: rawData.names.ru,
            engName: rawData.names.en,
            seasonAndType: getSeasonAndTypeText(),
            genres: getgenresText(),
            description: getDescriptionText(),
            series: getSeries(),
            playlist: getPlaylist())
        return animeItem
    }
}
