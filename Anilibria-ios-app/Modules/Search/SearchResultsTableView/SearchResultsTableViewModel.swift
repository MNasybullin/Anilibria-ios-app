//
//  SearchResultsTableViewModel.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 09.03.2023.
//

import UIKit

struct SearchResultsSectionsModel {
    var rowsData: [SearchResultsRowsModel]?
}

struct SearchResultsRowsModel {
    var ruName: String
    var engName: String?
    var description: String?
    var image: UIImage?
    var imageIsLoading: Bool = false
}
