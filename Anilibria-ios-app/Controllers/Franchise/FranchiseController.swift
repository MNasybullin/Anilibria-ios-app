//
//  FranchiseController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit

protocol FranchiseControllerDelegate: AnyObject {
    func showAnime(data: TitleAPIModel, image: UIImage?)
}

final class FranchiseController: UIViewController, HasCustomView {
    typealias CustomView = FranchiseView
    
    weak var delegate: FranchiseControllerDelegate?
    
    // for notification banner
    weak var animeView: UIView?
    
    private var contentController: FranchiseContentController!
    private let franchisesData: [FranchisesAPIModel]
    
    init(franchisesData: [FranchisesAPIModel]) {
        self.franchisesData = franchisesData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = FranchiseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        customView.manualUpdateConstraints()
    }
}

// MARK: - Private methods

private extension FranchiseController {
    func setupContentController() {
        contentController = FranchiseContentController(franchisesData: franchisesData, customView: customView)
        contentController.delegate = self
    }
}

extension FranchiseController: FranchiseContentControllerDelegate {
    func didSelectItem(data: TitleAPIModel, image: UIImage?) {
        delegate?.showAnime(data: data, image: image)
    }
    
    func removeFranchiseFromParent() {
        willMove(toParent: nil)
        removeFromParent()
        customView.removeFromSuperview()
        didMove(toParent: nil)
    }
}

// MARK: - HasPosterCellAnimatedTransitioning

extension FranchiseController: HasPosterCellAnimatedTransitioning {
    var selectedCell: PosterCollectionViewCell? {
        contentController.selectedCell
    }
    
    var selectedCellImageViewSnapshot: UIView? {
        contentController.selectedCellImageViewSnapshot
    }
}
