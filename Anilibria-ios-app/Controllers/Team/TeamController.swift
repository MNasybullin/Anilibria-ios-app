//
//  TeamController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 13.02.2024.
//

import UIKit

final class TeamController: UIViewController, HasCustomView, ProfileFlow {
    typealias CustomView = TeamView
    weak var navigator: ProfileNavigator?
    
    private let rawData: TeamAPIModel
    
    private var contentController: TeamContentController!
    
    init(rawData: TeamAPIModel) {
        self.rawData = rawData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = TeamView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentController()
    }
}

// MARK: - Private methods

private extension TeamController {
    func setupContentController() {
        contentController = TeamContentController(customView: customView, rawData: rawData)
    }
}
