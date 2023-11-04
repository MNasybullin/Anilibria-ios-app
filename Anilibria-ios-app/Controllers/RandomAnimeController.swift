//
//  RandomAnimeController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 01.11.2023.
//

import UIKit

protocol RandomAnimeControllerDelegate: AnyObject {
    func randomAnimeViewDidTapped(data: TitleAPIModel)
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
        customView.showSkeleton()
        model.requestData()
    }
}

// MARK: - RandomAnimeViewDelegate

extension RandomAnimeController: RandomAnimeViewDelegate {
    func refreshButtonDidTapped() {
        customView.refreshButton(isEnabled: false)
        customView.showSkeleton()
        model.requestData()
    }
    
    func viewTapped() {
        guard let rawData = model.getRawData(),
                model.isDataTaskLoading == false else {
            return
        }
        delegate?.randomAnimeViewDidTapped(data: rawData)
    }
}

// MARK: - RandomAnimeModelDelegate

extension RandomAnimeController: RandomAnimeModelDelegate {
    func update(data: RandomAnimeItem) {
        DispatchQueue.main.async {
            self.customView.hideSkeleton()
            self.customView.updateView(data: data)
            self.customView.refreshButton(isEnabled: true)
        }
    }
    
    func failedRequestData(error: Error) {
        DispatchQueue.main.async {
            self.customView.refreshButton(isEnabled: true)
        }
        print(#function)
    }
}
