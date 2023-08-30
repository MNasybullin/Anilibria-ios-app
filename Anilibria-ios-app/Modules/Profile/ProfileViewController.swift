//
//  ProfileViewController.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30/08/2023.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
	var presenter: ProfilePresenterProtocol! { get set }
}

final class ProfileViewController: UIViewController, ProfileViewProtocol {
	var presenter: ProfilePresenterProtocol!
}
