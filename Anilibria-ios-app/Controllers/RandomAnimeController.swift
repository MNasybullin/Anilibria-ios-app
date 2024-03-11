//
//  RandomAnimeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit
import OSLog

protocol RandomAnimeControllerDelegate: AnyObject {
    func randomAnimeViewDidTapped(data: TitleAPIModel, image: UIImage?)
}

final class RandomAnimeController: UIViewController, HasCustomView {
    typealias CustomView = RandomAnimeView
    
    private let model = RandomAnimeModel()
    
    weak var delegate: RandomAnimeControllerDelegate?
    
    override func loadView() {
        view = RandomAnimeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.delegate = self
        model.delegate = self
        customView.showSkeletonView()
        model.requestData()
    }
}

// MARK: - RandomAnimeViewDelegate

extension RandomAnimeController: RandomAnimeViewDelegate {
    func refreshButtonDidTapped() {
        customView.refreshButton(isEnabled: false)
        customView.configureLabelsForSkeleton()
        customView.layoutIfNeeded() // for skeleton
        customView.showSkeletonView()
        model.requestData()
    }
    
    func viewTapped() {
        let (data, image) = model.getRawData()
        guard model.isDataTaskLoading == false, let data else {
            return
        }
        
        delegate?.randomAnimeViewDidTapped(data: data, image: image)
    }
}

// MARK: - RandomAnimeModelDelegate

extension RandomAnimeController: RandomAnimeModelDelegate {
    func update(data: RandomAnimeItem) {
        DispatchQueue.main.async {
            self.customView.hideSkeletonView()
            self.customView.updateView(data: data)
            self.customView.refreshButton(isEnabled: true)
        }
    }
    
    func failedRequestData(error: Error) {
        DispatchQueue.main.async {
            self.customView.refreshButton(isEnabled: true)
        }
        let logger = Logger(subsystem: .anime, category: .data)
        logger.error("\(Logger.logInfo(error: error))")
        
        let data = NotificationBannerView.BannerData(title: Strings.RandomAnimeModule.Error.failedRequestData,
                                                     detail: error.localizedDescription,
                                                     type: .error)
        NotificationBannerView(data: data).show(onView: customView)
    }
}
