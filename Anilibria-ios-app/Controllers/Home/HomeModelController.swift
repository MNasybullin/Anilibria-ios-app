//
//  HomeModelController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import UIKit

class HomeModelController {
    typealias ResultImageBlock = (Result<UIImage, Error>) -> Void
    typealias DataBlock = ([HomeModel], HomeView.Section)
    typealias ResultDataBlock = (Result<DataBlock, Error>) -> Void
    
    fileprivate var rawData: [TitleAPIModel] = []
    fileprivate (set) var isDataTaskLoading = false
    fileprivate var isImageTasksLoading = AsyncDictionary<String, Bool>()

    fileprivate func requestImage(from urlString: String,
                                  completionHandler: @escaping ResultImageBlock) {
        Task {
            guard await isImageTasksLoading.get(urlString) != true else { return }
            await isImageTasksLoading.set(urlString, value: true)
            do {
                let imageData = try await ImageLoaderService.shared.getImageData(from: urlString)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                await isImageTasksLoading.set(urlString, value: false)
                completionHandler(.success(image))
            } catch {
                await isImageTasksLoading.set(urlString, value: nil)
                completionHandler(.failure(error))
            }
        }
    }
    
    func getImage(for model: HomeModel,
                  comletionHandler: @escaping (_: HomeModel) -> Void) {
        guard !model.imageUrlString.isEmpty else { return }
        
        requestImage(from: model.imageUrlString) { result in
            switch result {
                case .success(let image):
                    model.image = image
                    comletionHandler(model)
                case.failure(let error):
                    print(error)
            }
        }
    }
    
    func requestData(completionHanlder: @escaping ResultDataBlock) {
        guard isDataTaskLoading == false else {
            return
        }
        isDataTaskLoading = true
    }
}

// MARK: - HomeTodayModelController

class HomeTodayModelController: HomeModelController {
    override func requestData(completionHanlder: @escaping ResultDataBlock) {
        super.requestData(completionHanlder: completionHanlder)
        Task {
            defer {
                isDataTaskLoading = false
            }
            do {
                let data = try await PublicApiService.shared.getSchedule(with: [.currentDayOfTheWeek()])
                guard let todayTitleModels = data.first?.list else {
                    throw MyInternalError.failedToFetchData
                }
                rawData = todayTitleModels
                let animeTitleModels = todayTitleModels.map { HomeModel(from: $0) }
                completionHanlder(.success((animeTitleModels, .today)))
            } catch {
                completionHanlder(.failure(error))
            }
        }
    }
}

// MARK: - HomeUpdatesModelController

class HomeUpdatesModelController: HomeModelController {
    override func requestData(completionHanlder: @escaping ResultDataBlock) {
        super.requestData(completionHanlder: completionHanlder)
        Task {
            defer {
                isDataTaskLoading = false
            }
            do {
                let data = try await PublicApiService.shared.getUpdates()
                rawData = data
                let animeTitleModels = data.map { HomeModel(from: $0) }
                completionHanlder(.success((animeTitleModels, .updates)))
            } catch {
                completionHanlder(.failure(error))
            }
        }
    }
}
