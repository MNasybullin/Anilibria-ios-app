//
//  HomeModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 17.10.2023.
//

import UIKit

class HomeModel {
    var identifier: String = UUID().uuidString
    var name: String
    var imageUrlString: String
    var image: UIImage?
    
    init(name: String, imageUrlString: String, image: UIImage? = nil) {
        self.name = name
        self.imageUrlString = imageUrlString
        self.image = image
    }
    
    convenience init(from model: TitleAPIModel) {
        self.init(name: model.names.ru,
                  imageUrlString: model.posters?.original?.url ?? "",
                  image: nil)
    }
}

extension HomeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // swiftlint: disable operator_whitespace
    static func ==(lhs: HomeModel, rhs: HomeModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    // swiftlint: enable operator_whitespace
}

class HomeBaseModel {
    typealias ResultBlock = Result<UIImage, Error>
    
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
}

class HomeTodayModel: HomeBaseModel {
    weak var delegate: HomeTodayContentControllerDelegate?
    
    func requestData() {
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
                self.delegate?.update(todayData: animeTitleModels)
            } catch {
                
            }
        }
    }
    
    func getImage(for urlString: String, indexPath: IndexPath) {
        requestImage(from: urlString) { result in
            switch result {
                case .success(let image):
                    self.delegate?.update(todayImage: image, for: indexPath)
                case.failure(let error):
                    print(error)
            }
        }
    }
}

class HomeUpdatesModel: HomeBaseModel {
    weak var delegate: HomeUpdatesContentControllerDelegate?
    
    func requestData() {
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
                self.delegate?.update(updatesData: animeTitleModels)
            } catch {
                
            }
        }
    }
    
    func getImage(for urlString: String, indexPath: IndexPath) {
        requestImage(from: urlString) { result in
            switch result {
                case .success(let image):
                    self.delegate?.update(updatesImage: image, for: indexPath)
                case.failure(let error):
                    print(error)
            }
        }
    }
}
