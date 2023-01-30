//
//  PostersListViewModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 30.01.2023.
//

import Foundation
import UIKit

struct PostersListViewModel {
    var headerName: String?
    var postersList: [PostersListModel]
}

struct PostersListModel {
    var name: String
    var image: UIImage?
    var imageIsLoading: Bool = false
}
