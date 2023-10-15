//
//  AnimeInteractor.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17/03/2023.
//

import UIKit

protocol AnimeInteractorProtocol: AnyObject {
	var presenter: AnimePresenterProtocol! { get set }
    
    func getData() -> AnimeModel
    func requestImage() async throws -> UIImage
}

final class AnimeInteractor: AnimeInteractorProtocol {
    weak var presenter: AnimePresenterProtocol!
    
    var titleModel: TitleAPIModel
    var animeModel: AnimeModel!
    
    init(data: TitleAPIModel) {
        self.titleModel = data
        self.animeModel = AnimeModel(image: nil,
//                                     imageIsLoading: false,
                                     ruName: getRuNameText(),
                                     engName: getEngNameText(),
                                     seasonAndType: getSeasonAndTypeText(),
                                     genres: getgenresText(),
                                     description: getDescriptionText(),
                                     series: getSeries(),
                                     playlist: getPlaylist())
    }
    
    func getData() -> AnimeModel {
        return animeModel
    }
    
    func requestImage() async throws -> UIImage {
        guard let imageURL = titleModel.posters?.original?.url else {
            throw MyInternalError.failedToFetchURLFromData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            guard let image = UIImage(data: imageData) else {
                throw MyImageError.failedToInitialize
            }
            animeModel.image = image
            return image
        } catch {
            throw error
        }
    }
    
    private func getRuNameText() -> String {
        return titleModel.names.ru
    }
    
    private func getEngNameText() -> String? {
        return titleModel.names.en
    }
    
    private func getSeasonAndTypeText() -> String {
        let year = titleModel.season?.year?.description == nil ? "" : (titleModel.season?.year?.description)! + " "
        let season = titleModel.season?.string == nil ? "" : (titleModel.season?.string)! + ", "
        let type = titleModel.type?.fullString ?? ""
        return year + season + type
    }
    
    private func getgenresText() -> String? {
        return titleModel.genres?.joined(separator: ", ")
    }
    
    private func getDescriptionText() -> String? {
        return titleModel.description?.replacingOccurrences(of: "[\r\n]{3,}", with: "\n\n", options: .regularExpression, range: nil)
    }
    
    private func getSeries() -> GTSeries? {
        return titleModel.player?.series
    }
    
    private func getPlaylist() -> [Playlist] {
        var array = [Playlist]()
        titleModel.player?.playlist?.forEach { item in
            array.append(Playlist(serie: item.serie,
                                  serieString: getSerieString(from: item.serie),
                                  createdTimestamp: item.createdTimestamp,
                                  createdDateString: getCreatedDateString(from: item.createdTimestamp),
                                  preview: item.preview,
                                  image: nil,
                                  skips: item.skips,
                                  hls: item.hls))
        }
        return array
    }
    
    private func getSerieString(from serie: Double?) -> String {
        var serieString = ""
        if serie != nil {
            let int = Int(exactly: serie!)
            let numberString: String = int == nil ? serie!.description : int!.description
            serieString = numberString + " " + "серия"
        }
        return serieString
    }
    
    private func getCreatedDateString(from createdTimestamp: Int?) -> String {
        var createdDateString = ""
        if let timestamp = createdTimestamp {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            createdDateString = date.formatted(date: .long, time: .omitted)
        }
        return createdDateString
    }
}
