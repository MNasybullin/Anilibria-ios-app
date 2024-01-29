//
//  FranchiseController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 26.01.2024.
//

import UIKit

final class FranchiseController: UIViewController, HasCustomView {
    typealias CustomView = FranchiseView
    
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
        
        contentController = FranchiseContentController(franchisesData: franchisesData, customView: customView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        customView.manualUpdateConstraints()
    }
}
