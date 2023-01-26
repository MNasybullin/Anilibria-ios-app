//
//  PostersListViewModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 03.12.2022.
//

import Foundation
import UIKit

struct PostersListViewModel {
    var headerString: String?
    var list: [PostersListModel]
}

struct PostersListModel {
    var title: String
    var image: UIImage?
    var imageIsLoading: Bool = false
}
