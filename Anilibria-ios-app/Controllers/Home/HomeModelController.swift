//
//  HomeModelController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import UIKit

class HomeModelController {
    typealias ResultBlock = Result<UIImage, Error>
    
    weak var delegate: HomeContentControllerDelegate?
    
    fileprivate var rawData: [TitleAPIModel] = []
    fileprivate var isDataTaskLoading = false
    fileprivate var isImageTasksLoading: [String: Bool] = [:]

    fileprivate func requestImage(from urlString: String,
                                  completionHandler: @escaping (ResultBlock) -> Void) {
        guard isImageTasksLoading[urlString] == nil else {
            return
        }
        isImageTasksLoading[urlString] = true
        Task {
            do {
                let imageData = try await ImageLoaderService.shared.getImageData(from: urlString)
                guard let image = UIImage(data: imageData) else {
                    throw MyImageError.failedToInitialize
                }
                isImageTasksLoading[urlString] = false
                completionHandler(.success(image))
            } catch {
                isImageTasksLoading[urlString] = nil
                completionHandler(.failure(error))
            }
        }
    }
    
    func getImage(for model: HomeModel) {
        requestImage(from: model.imageUrlString) { result in
            switch result {
                case .success(let image):
                    model.image = image
                    self.delegate?.reconfigure(data: model)
                case.failure(let error):
                    print(error)
            }
        }
    }
    
    func requestData() {
        fatalError("You must override this method in child class")
    }
}

// MARK: - HomeTodayModelController

class HomeTodayModelController: HomeModelController {
    override func requestData() {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
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
                self.delegate?.update(data: animeTitleModels, from: .today)
            } catch {
                
            }
        }
    }
}

// MARK: - HomeUpdatesModelController

class HomeUpdatesModelController: HomeModelController {
    override func requestData() {
        guard isDataTaskLoading == false else { return }
        isDataTaskLoading = true
        Task {
            defer {
                isDataTaskLoading = false
            }
            do {
                let data = try await PublicApiService.shared.getUpdates()
                rawData = data
                let animeTitleModels = data.map { HomeModel(from: $0) }
                self.delegate?.update(data: animeTitleModels, from: .updates)
            } catch {
                
            }
        }
    }
}
