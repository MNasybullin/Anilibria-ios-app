//
//  SignInController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 14.10.2023.
//

import UIKit

protocol SignInControllerDelegate: AnyObject {
    func authorizationIsSuccessful()
    func authorizationIsFailure(error: Error)
}

final class SignInController: UIViewController, HasCustomView {
    typealias CustomView = SignInView
    let model = SignInModel()
    weak var delegate: SignInControllerDelegate?
    
    override func loadView() {
        let signInView = SignInView()
        signInView.delegate = self
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SignInViewDelegate

extension SignInController: SignInViewDelegate {
    func signInButtonTapped(email: String, password: String) {
        model.authorization(email: email, password: password) { [weak self] result in
            switch result {
                case .success:
                    self?.delegate?.authorizationIsSuccessful()
                case .failure(let error):
                    self?.delegate?.authorizationIsFailure(error: error)
            }
        }
    }
}
