//
//  UserInfoController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

protocol UserInfoControllerDelegate: AnyObject {
    func getUserInfoIsFailure(error: Error)
}

final class UserInfoController: UIViewController, HasCustomView {
    typealias CustomView = UserInfoView
    
    weak var delegate: UserInfoControllerDelegate?
    
    private let model = UserInfoModel()
    
    override func loadView() {
        let userInfoView = UserInfoView()
        view = userInfoView
    }
    
    func configureView(successClosure: @escaping () -> Void) {
        model.getUserInfo { [weak self] result in
            switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self?.customView.set(image: user.image)
                        self?.customView.set(userName: user.name)
                        successClosure()
                    }
                case .failure(let error):
                    self?.delegate?.getUserInfoIsFailure(error: error)
            }
        }
    }
}
