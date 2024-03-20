//
//  ScheduleController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 25.10.2023.
//

import UIKit

final class ScheduleController: UIViewController, HomeFlow, HasCustomView {
    typealias CustomView = ScheduleView
    weak var navigator: HomeNavigator?
    
    private var contentController: ScheduleContentController!
    
    override func loadView() {
        view = ScheduleView(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
}

// MARK: - Private methods

private extension ScheduleController {
    func setupContentController() {
        contentController = ScheduleContentController(customView: customView, delegate: self)
    }
}

// MARK: - ScheduleViewDelegate

extension ScheduleController: ScheduleViewDelegate {
    func refreshButtonDidTapped() {
        contentController.requestData()
    }
}

// MARK: - ScheduleContentControllerDelegate

extension ScheduleController: ScheduleContentControllerDelegate {
    func didSelectItem(_ rawData: TitleAPIModel, image: UIImage?) {
        navigator?.show(.anime(data: rawData, image: image))
    }
}

// MARK: - HasPosterCellAnimatedTransitioning

extension ScheduleController: HasPosterCellAnimatedTransitioning {
    var selectedCell: PosterCollectionViewCell? {
        contentController.selectedCell
    }
    
    var selectedCellImageViewSnapshot: UIView? {
        contentController.selectedCellImageViewSnapshot
    }
}
