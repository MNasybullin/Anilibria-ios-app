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
    func requestImage() async throws -> UIImage?
}

final class AnimeInteractor: AnimeInteractorProtocol {
    unowned var presenter: AnimePresenterProtocol!
    
    var titleModel: GetTitleModel
    var animeModel: AnimeModel!
    
    init(data: GetTitleModel) {
        self.titleModel = data
        self.animeModel = AnimeModel(image: nil,
//                                     imageIsLoading: false,
                                     ruName: getRuNameText(),
                                     engName: getEngNameText(),
                                     seasonAndType: getSeasonAndTypeText(),
                                     genres: getgenresText(),
                                     description: getDescriptionText())
        
    }
    
    func getData() -> AnimeModel {
        return animeModel
    }
    
    func requestImage() async throws -> UIImage? {
        guard let imageURL = titleModel.posters?.original?.url else {
            throw MyInternalError.failedToFetchData
        }
        do {
            let imageData = try await ImageLoaderService.shared.getImageData(from: imageURL)
            let image = UIImage(data: imageData)
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
}
